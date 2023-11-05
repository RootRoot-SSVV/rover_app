import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/panels.dart';

class Panel extends StatelessWidget {
  final IconData menuIcon = Icons.keyboard_arrow_up_rounded;

  const Panel({super.key});

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<Panels>(context);

    return DefaultTabController(
        length: _provider.listOfPanels.length,
        child: Scaffold(
          bottomNavigationBar: TabBar(
              tabs: _provider.listOfTabButtons,
              isScrollable: true,
              physics: BouncingScrollPhysics(),
              labelColor: Colors.blueGrey),
          body: TabBarView(children: _provider.listOfPanels),
        ));
  }
}
