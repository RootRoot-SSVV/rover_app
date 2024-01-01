import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/panel_screens/screens/main_panel.dart';
import 'package:rover_app/panel_screens/screens/temperature_module.dart';
import 'package:rover_app/panel_screens/screens/ultrasonic_module.dart';
import 'package:rover_app/providers/bt_controller.dart';

import 'dart:developer' as dev;

class Panels extends ChangeNotifier {
  final Map<int, StatelessWidget> moduleById = {
    16: const MainPanel(),
    0: const TemperatureModule(),
    1: const UltrasonicModule()
  };

  int currentPageIndex = 0;

  List<Widget> listOfPanels = [MainPanel()];

  List<Tab> listOfTabButtons = [Tab(text: 'Home', icon: Icon(Icons.home))];

  void updateLists(List<int> message) {
    dev.log('amogus');
    List<int> connectedModules = List.from(message.getRange(2, 2 + message[1]));

    listOfPanels.clear();
    listOfTabButtons.clear();

    listOfPanels.add(moduleById[16]!);
    listOfTabButtons.add(const Tab(text: 'Home', icon: Icon(Icons.home)));

    for (int i = 0; i < connectedModules.length; i++) {
      listOfPanels.add(moduleById[connectedModules[i]]!);
      listOfTabButtons.add(Tab(text: i.toString(), icon: Icon(Icons.clear)));
    }

    dev.log('$listOfPanels');
    notifyListeners();
  }

  void changeToModule(BuildContext context, int mode) {
    final provider = Provider.of<BtController>(context, listen: false);
    if (provider.mode != mode) {
      Provider.of<BtController>(context, listen: false).mode = mode;
      Provider.of<BtController>(context, listen: false)
          .sendMessage(changingModule: true);
    }
  }

  Widget foo() {
    return DefaultTabController(
        length: listOfPanels.length,
        child: Scaffold(
          bottomNavigationBar: TabBar(
              tabs: listOfTabButtons,
              isScrollable: (listOfPanels.length > 7),
              physics: const BouncingScrollPhysics(),
              labelColor: Colors.blueGrey),
          body: TabBarView(children: listOfPanels),
        ));
  }
}
