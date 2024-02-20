import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/bt_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rover_app/providers/panels.dart';

/// Glavni panel
/// 
/// Služi za izlazak iz aplikacije i ponovno skeniranje modula
class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<Panels>(context, listen: false).changeToModule(context, 16);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.exit_to_app),
            label: Text(AppLocalizations.of(context)!.exit_button),
          ),
          Consumer<BtController>(
            builder: (context, btController, child) {
              return OutlinedButton.icon(
                onPressed: () => btController.scanForModules(),
                icon: const Icon(Icons.replay),
                label: Text(AppLocalizations.of(context)!.rescan_button),
              );
            },
          ),
        ],
      ),
    );
  }
}
