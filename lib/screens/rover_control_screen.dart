import 'package:flutter/material.dart';
import 'package:rover_app/panel_screens/panel.dart';
import 'package:rover_app/widgets/control_button.dart';

class RoverControlScreen extends StatelessWidget {
  const RoverControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: const [
                    ControlButton(icon: Icons.arrow_upward, value: 1),
                    ControlButton(icon: Icons.arrow_downward, value: 2)
                  ],
                ),
              )),
          const Expanded(flex: 6, child: Panel()),
          Expanded(
              flex: 2,
              child: Center(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: const [
                    ControlButton(icon: Icons.arrow_back, value: 4),
                    ControlButton(icon: Icons.arrow_forward, value: 8)
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
