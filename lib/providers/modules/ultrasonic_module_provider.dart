import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rover_app/providers/bt_controller.dart';

import 'dart:developer' as dev;

/// Demo modul provider
///
/// Sadrži jedan ultrasonic modul
/// Šalje i prima podatke
/// Šalje u formatu
///   [trig]
/// Prima u formatu
///   [prvi broj][drugi broj]
///   udaljenost = prvi broj + drugi broj
class UltrasonicModuleProvider extends ChangeNotifier {
  int distance = 0;

  void getDistance(List<int> inputBuffer) {
    distance = inputBuffer[1] + inputBuffer[2];
    notifyListeners();
  }

  void startUltrasonicService(BtController bt) async {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 1500), () {
        dev.log('us');
        List<int> message = [1];
        bt.changeDataForModule(message);
        if (bt.mode == 1) {

          dev.log('us sent');
          bt.sendMessage();
        }
      });
    }
  }
}
