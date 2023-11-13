import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.bluetooth_disabled),
              label: Text('Disconnect')),
          OutlinedButton.icon(
              onPressed: () {
                
                // Add sending messages / rescaning

                Provider.of<Panels>(context, listen: false).updateLists(context);
              },
              icon: const Icon(Icons.replay),
              label: Text('Rescan')),
        ],
      ),
    );
  }
}
