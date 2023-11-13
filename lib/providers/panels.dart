import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/panel_screens/screens/main_panel.dart';
import 'package:rover_app/panel_screens/screens/temperature_module.dart';
import 'package:rover_app/panel_screens/screens/ultrasonic_module.dart';
import 'package:rover_app/providers/bt_controller.dart';

class Panels extends ChangeNotifier {
  final Map<int, StatelessWidget> moduleById = {
    16: const MainPanel(),
    0: const TemperatureModule(),
    1: const UltrasonicModule()
  };

  int currentPageIndex = 0;

  List<Widget> listOfPanels = [MainPanel()];

  List<Tab> listOfTabButtons = [Tab(text: 'Home', icon: Icon(Icons.home))];

  void updateLists(BuildContext context) {
    final _btController = Provider.of<BtController>(context, listen: false);

    listOfPanels.clear();
    listOfTabButtons.clear();

    listOfPanels.add(moduleById[16]!);
    listOfTabButtons.add(const Tab(text: 'Home', icon: Icon(Icons.home)));

    for (int i = 0; i < _btController.connectedModules.length; i++) {
      listOfPanels.add(moduleById[_btController.connectedModules[i]]!);
      listOfTabButtons.add(Tab(text: i.toString(), icon: Icon(Icons.clear)));
    }
    notifyListeners();
  }

  void destinationSelected(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  Widget getCurrentPanel() {
    return listOfPanels[currentPageIndex];
  }
}