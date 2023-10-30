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
//     0-15    =   module selection
//     16      =   no special action
//     17      =   rescan for modules
//     18      =   disconnect
//

enum Mode {
  nil(16),
  rescan(17),
  disconnect(18);

  const Mode(this.value);
  final int value;
}

class BtController extends ChangeNotifier {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  Uint8List messageBuffer = Uint8List(64);
  int motorControl = 0;
  List<int> dataForModule = List.filled(64, 0);
  List<int> connectedModules = [];

  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);

  bool isDiscovering = false;

  String _address = "...";
  String _name = "...";

  // TODO: adding msg variable (list or int), we'll see later

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BluetoothConnection? connection;

  // TODO:
  // Later see if this is necessary, idk if we need to get device adress and name,
  // I think that we only need from line 32 to 44
  BtController() {
    FlutterBluetoothSerial.instance.state
        .then((state) => _bluetoothState = state);

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

      dev.log('Connected');

      connection?.input?.listen((Uint8List data) {
        messageBuffer.setRange(0, data.length, data);
      }).onDone(() => dev.log('Disconnected'));
    } catch (e) {
      dev.log('Cannot connect');
    }
  }

  void sendMessage(Mode mode) async {
    Uint8List message =
        Uint8List.fromList([mode.value, motorControl] + dataForModule);

    try {
      connection!.output.add(message);
      await connection!.output.allSent;
    } catch (e) {}
  }

  void scanForModules() {
    // Testing other
    //sendMessage(Mode.rescan);
    //connectedModules.addAll(messageBuffer);

    connectedModules = [0, 1];

    notifyListeners();
  }
}
