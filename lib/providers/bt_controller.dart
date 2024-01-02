import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as dev;

import 'package:rover_app/providers/panels.dart';
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
//     19      =   change module to    [19][movement][moduleId][]...    // No return message
//

class BtController extends ChangeNotifier {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  bool bluetoothIsOn = true;

  List<int> inputBuffer = List<int>.empty(growable: true);

  int motorControl = 0;
  List<int> dataForModule = List.filled(62, 0);
  List<int> connectedModules = List<int>.empty(growable: true);
  int mode = 16;

  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);

  bool isDiscovering = false;

  Timer? _discoverableTimeoutTimer;

  BluetoothConnection? connection;

  final Panels _panelsProvider;

  BtController(this._panelsProvider) {
    FlutterBluetoothSerial.instance.state
        .then((state) => _bluetoothState = state);

    notifyListeners();

    Future.doWhile(() async {
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {});

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      _bluetoothState = state;
      _discoverableTimeoutTimer = null;
    });
  }

  /// Here add all functions for module panels update
  void messageReaction(List<int> message) {
    switch (message[0]) {
      case 17:
        _panelsProvider.updateLists(message);
        break;
      default:
        dev.log('no case');
    }
    notifyListeners();
  }

  BtController.fromCollection(this.connection, this._panelsProvider) {
    connection?.input!.listen((data) {
      inputBuffer += data;

      while (true) {
        int index = inputBuffer.indexOf(254);
        if (index >= 0 && inputBuffer.length - index >= 60) {
          List<int> dataReceivedList =
              List.from(inputBuffer.getRange(index + 1, index + 60));
          messageReaction(dataReceivedList);
          inputBuffer.removeRange(0, index + 60);
        } else {
          break;
        }
      }
      notifyListeners();
    }).onDone(() {
      dev.log('Disconnected');
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

  Future<BtController> connectWith(String address) async {
    _streamSubscription?.cancel();
    connection = await BluetoothConnection.toAddress(address);
    return BtController.fromCollection(connection, _panelsProvider);
  }

  void sendMessage({bool changingModule = false}) async {
    Uint8List message;
    if (!changingModule) {
      message = Uint8List.fromList([254, mode, motorControl] + dataForModule);
    } else {
      message = Uint8List.fromList(
          [254, 19, motorControl, mode] + List.filled(61, 0));
    }

    try {
      connection!.output.add(message);
      await connection!.output.allSent;
    } catch (e) {
      dev.log('Catch in: void sendMessage()');
    }
  }

  void scanForModules() async {
    mode = 18;
    sendMessage();
    mode = 16;
    notifyListeners();
  }
}
