import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/panels.dart';

class Panel extends StatelessWidget {
  final IconData menuIcon = Icons.keyboard_arrow_up_rounded;

  const Panel({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Panels>(context);

    return DefaultTabController(
        length: provider.listOfPanels.length,
        child: Scaffold(
          bottomNavigationBar: TabBar(
              tabs: provider.listOfTabButtons,
              isScrollable: (provider.listOfPanels.length > 7),
              physics: const BouncingScrollPhysics(),
              labelColor: Colors.blueGrey),
          body: TabBarView(children: provider.listOfPanels),
        ));
  }
}
