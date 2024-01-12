import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/panels.dart';

class UltrasonicModulePanel extends StatelessWidget {
  const UltrasonicModulePanel({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<Panels>(context, listen: false).changeToModule(context, 1);

    return const Placeholder();
  }
}
