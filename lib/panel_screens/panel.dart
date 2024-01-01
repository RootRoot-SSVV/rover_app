import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/panels.dart';

import 'dart:developer' as dev;

class Panel extends StatelessWidget {
  const Panel({super.key});

  @override
  Widget build(BuildContext context) {
    dev.log('Rebuilding');
    return Consumer<Panels>(
      builder: (context, panelsProvider, child) {
        return DefaultTabController(
          length: panelsProvider.listOfPanels.length,
          child: Scaffold(
            bottomNavigationBar: TabBar(
              tabs: panelsProvider.listOfTabButtons,
              isScrollable: (panelsProvider.listOfPanels.length > 7),
              physics: const BouncingScrollPhysics(),
              labelColor: Colors.blueGrey,
            ),
            body: TabBarView(children: panelsProvider.listOfPanels),
          ),
        );
      },
    );
  }
}
