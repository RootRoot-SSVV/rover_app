import 'package:flutter/material.dart';
import 'package:rover_app/providers/bt_controller.dart';

class DemoModuleProvider extends ChangeNotifier {
  bool led1 = false, led2 = false, led3 = false;
  double red = 0, green = 0, blue = 0;

  void led1Change(bool value, BtController bt) {
    led1 = value;
    sendMessage(bt);
    notifyListeners();
  }

  void led2Change(bool value, BtController bt) {
    led2 = value;
    sendMessage(bt);
    notifyListeners();
  }

  void led3Change(bool value, BtController bt) {
    led3 = value;
    sendMessage(bt);
    notifyListeners();
  }

  void redChange(double value, BtController bt) {
    red = value;
    notifyListeners();
  }

  void greenChange(double value, BtController bt) {
    green = value;
    notifyListeners();
  }

  void blueChange(double value, BtController bt) {
    blue = value;
    notifyListeners();
  }

  void sendMessage(BtController bt) {
    List<int> message = [
      led1 ? 1 : 0,
      led2 ? 1 : 0,
      led3 ? 1 : 0,
      red.floor(),
      green.floor(),
      blue.floor()
    ];
    bt.changeDataForModule(message);
    bt.sendMessage();
  }
}
