import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/panels.dart';

class Panel extends StatelessWidget {
  const Panel({super.key});

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<Panels>(context);
    int currentIndex = _provider.currentPageIndex;

    return Scaffold(
        bottomNavigationBar: NavigationBar(
          destinations: _provider.navigationDestinations,
          onDestinationSelected: (int index) {
            _provider.destinationSelected(index);
          },
          selectedIndex: currentIndex,
        ),
        body: Provider.of<Panels>(context, listen: false).getCurrentPanel());
  }
}
