import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/panels.dart';

class Panel extends StatelessWidget {
  const Panel({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Consumer<Panels> to listen to changes in Panels provider
    return Consumer<Panels>(
      builder: (context, panelsProvider, child) {
        // The UI inside here will rebuild whenever Panels notifies its listeners
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
