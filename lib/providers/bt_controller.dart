import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'dart:developer' as dev;

// Communication rules:
//
// Sending:
// data_buffer = [mode][movement][additional data][additional data]...
//
// modes:
//     0-15    =   module selection    [0-15][movement][]...
//     16      =   no special action   [16][movement][]...
//     17      =   rescan for modules  [17][movement][]...
//     18      =   disconnect          [18][]
//     19      =   change module to    [19][movement][moduleId][]...
//

class BtController extends ChangeNotifier {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  bool bluetoothIsOn = true;

  Uint8List messageBuffer = Uint8List(64);
  int motorControl = 0;
  List<int> dataForModule = List.filled(62, 0);
  List<int> connectedModules = [];
  late int mode;

  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);

  bool isDiscovering = false;

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BluetoothConnection? connection;

  BtController() {
    mode = 16;

    dev.log('$_bluetoothState');
    FlutterBluetoothSerial.instance.state
        .then((state) => _bluetoothState = state);

    dev.log('$_bluetoothState');
    notifyListeners();

    Future.doWhile(() async {
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      FlutterBluetoothSerial.instance.address
          .then((address) => _address = address!);
    });

    FlutterBluetoothSerial.instance.name.then((name) => _name = name!);

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      _bluetoothState = state;
      _discoverableTimeoutTimer = null;
      _discoverableTimeoutSecondsLeft = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
  }

  void startDiscovery() {
    if (_bluetoothState == BluetoothState.ERROR ||
        _bluetoothState == BluetoothState.STATE_OFF ||
        _bluetoothState == BluetoothState.UNKNOWN) {
      bluetoothIsOn = false;
      return;
    }

    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      final existingIndex = results
          .indexWhere((element) => element.device.address == r.device.address);
      if (existingIndex >= 0) {
        results[existingIndex] = r;
      } else {
        results.add(r);
      }
      notifyListeners();
    });
    _streamSubscription!.onDone(() {
      isDiscovering = false;
      notifyListeners();
    });
  }

  void restartDiscovery() {
    results.clear();
    isDiscovering = true;

    startDiscovery();
  }

  void connectWith(String address) async {
    _streamSubscription?.cancel();

    try {
      connection = await BluetoothConnection.toAddress(address);

      connection?.input?.listen((Uint8List data) {
        // Message receiving, probably
      }).onDone(() => dev.log('Disconnected'));
    } catch (e) {
      dev.log('Cannot connect');
    }
  }

  void sendMessage({bool changingModule = false}) async {
    Uint8List message;

    if (!changingModule) {
      message = Uint8List.fromList([mode, motorControl] + dataForModule);
    } else {
      message =
          Uint8List.fromList([19, motorControl, mode] + List.filled(61, 0));
    }

    dev.log('$message');

    try {
      connection!.output.add(message);
      await connection!.output.allSent;
    } catch (e) {
      dev.log('Catch in send message');
    }
  }

  void scanForModules() {
    // TODO: Sending messages and updating lists
    notifyListeners();
  }
}
