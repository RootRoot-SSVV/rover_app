import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/panels.dart';

class TemperatureModule extends StatelessWidget {
  const TemperatureModule({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<Panels>(context, listen: false).changeToModule(context, 0);
    
    return const Placeholder();
  }
}
