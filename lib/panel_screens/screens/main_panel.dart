import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/bt_controller.dart';
import 'package:rover_app/providers/panels.dart';

class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.bluetooth_disabled),
              label: Text('Disconnect')),
          ElevatedButton.icon(
              onPressed: () {
                Provider.of<BtController>(context, listen: false)
                    .scanForModules();
                Provider.of<Panels>(context, listen: false).updateLists(context);
              },
              icon: const Icon(Icons.replay),
              label: Text('Rescan')),
        ],
      ),
    );
  }
}
