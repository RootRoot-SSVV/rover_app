import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'dart:developer' as Dev;

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
  temperature(0),
  ultrasonic(1),
  nil(16),
  rescan(17),
  disconnect(18);

  const Mode(this.value);
  final int value;
}

class BtController extends ChangeNotifier {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  bool bluetoothIsOn = true;

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
  // Later see if this is necessary, idk if we need to get device adress and name
  BtController() {
    Dev.log('$_bluetoothState');
    FlutterBluetoothSerial.instance.state
        .then((state) => _bluetoothState = state);

    Dev.log('$_bluetoothState');
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

      }).onDone(() => Dev.log('Disconnected'));
    } catch (e) {
      Dev.log('Cannot connect');
    }
  }

  void sendMessage(Mode mode) async {
    Uint8List message =
        Uint8List.fromList([mode.value, motorControl] + dataForModule);

    Dev.log('$message');

    try {
      connection!.output.add(message);
      await connection!.output.allSent;
    } catch (e) {}
  }

  void scanForModules() {
    
    // Sending messages and updating lists

    notifyListeners();
  }

  void selectModule(Mode module) {
    // Send message for new mode
  }
}
