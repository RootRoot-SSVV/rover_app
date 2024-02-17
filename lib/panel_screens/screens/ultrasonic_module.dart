import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/bt_controller.dart';
import 'package:rover_app/providers/modules/ultrasonic_module_provider.dart';
import 'package:rover_app/providers/panels.dart';

/// UI ultrasonic modula
/// Sadrži prikaz podataka senzora udaljenosti
/// Koristi [UltrasonicModuleProvider]
class UltrasonicModulePanel extends StatelessWidget {
  const UltrasonicModulePanel({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<Panels>(context, listen: false).changeToModule(context, 1);
    if (!Provider.of<UltrasonicModuleProvider>(context, listen: false)
        .selected) {
      Provider.of<UltrasonicModuleProvider>(context, listen: false).selected =
          true;
      Provider.of<UltrasonicModuleProvider>(context)
          .startUltrasonicService(Provider.of<BtController>(context));
    }

    return Center(
        child: Text(
            '${Provider.of<UltrasonicModuleProvider>(context).distance} cm'));
  }
}
