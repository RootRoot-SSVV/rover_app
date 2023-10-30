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

  List<NavigationDestination> navigationDestinations = [
    NavigationDestination(icon: Icon(Icons.cancel), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.cancel), label: 'No module')
  ];

  List<Widget> listOfPanels = [MainPanel(), Placeholder()];

  void updateLists(BuildContext context) {
    final _btController = Provider.of<BtController>(context, listen: false);

    listOfPanels.clear();
    navigationDestinations.clear();

    listOfPanels.add(moduleById[16]!);
    navigationDestinations
        .add(NavigationDestination(icon: Icon(Icons.home), label: 'Home'));

    for (int i = 0; i < _btController.connectedModules.length; i++) {
      listOfPanels.add(moduleById[_btController.connectedModules[i]]!);
      navigationDestinations.add(
          NavigationDestination(icon: Icon(Icons.clear), label: i.toString()));
    }

    if (navigationDestinations.length < 2) {
      listOfPanels.add(moduleById[16]!);
      navigationDestinations.add(
          NavigationDestination(icon: Icon(Icons.clear), label: 'No module'));
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
