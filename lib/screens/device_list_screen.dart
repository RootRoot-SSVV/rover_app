import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/bluetooth/bt_controller.dart';
import 'package:rover_app/l10n/l10n.dart';
import 'package:rover_app/l10n/translation_provider.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(translation(context).discover_devices),
          actions: <Widget>[
            Provider.of<BtController>(context).isDiscovering
                ? FittedBox(
                    child: Container(
                        margin: const EdgeInsets.all(16.0),
                        child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))))
                : IconButton(
                    onPressed: () {
                      Provider.of<BtController>(context, listen: false)
                          .restartDiscovery();
                    },
                    icon: const Icon(Icons.replay)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                  onChanged: (Language? language) async {

                    // FIXME:
                    // I've deleted all of this, not sure how to write it

                  },
                  items: Language.languageList()
                      .map<DropdownMenuItem<Language>>((e) =>
                          DropdownMenuItem<Language>(
                            value: e,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[Text(e.flag), Text(e.name)],
                            ),
                          ))
                      .toList()),
            )
          ],
        ),
        body: Consumer<BtController>(builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.results.length,
            itemBuilder: (context, index) {
              BluetoothDiscoveryResult result = value.results[index];
              final device = result.device;
              final address = result.device.address;

              return ListTile(
                title: Text(device.name ?? translation(context).noName),
                subtitle: Text(address),
                onTap: () {
                  value.connectWith(address);
                  context.go('/controlScreen');
                },
              );
            },
          );
        }),
      ),
    );
  }
}
