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
///   ???
class UltrasonicModuleProvider extends ChangeNotifier {
  int distance = 0;
  bool selected = false;

  /// Pretvara poruku u `double`
  void getDistance(List<int> inputBuffer) {
    distance = inputBuffer[1];

    dev.log('got distance');

    notifyListeners();
  }

  void startUltrasonicService(BtController bt) async {
    if (selected) {
      await Future.delayed(const Duration(seconds: 2), () {
        if (selected) {
          dev.log('sending, ultrasonic');
          List<int> message = [1];
          bt.changeDataForModule(message);
          bt.sendMessage();
          startUltrasonicService(bt); // Recursive call
        }
        selected = false;
        notifyListeners();
      });
    }
  }
}
