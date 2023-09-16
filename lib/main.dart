import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/bluetooth/bt_controller.dart';
import 'package:rover_app/l10n/l10n.dart';
import 'package:rover_app/l10n/locale_provider.dart';
import 'package:rover_app/screens/device_list_screen.dart';
import 'package:rover_app/screens/privacy_policy_screen.dart';
import 'package:rover_app/screens/rover_control_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((value) {
    [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) {
      runApp(MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => BtController())],
          child: MainApp()));
    });
  });
}

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(path: '/', builder: (context, state) => DeviceListScreen()),
  GoRoute(
    path: '/controlScreen',
    builder: (context, state) => RoverControlScreen(),
  ),
  GoRoute(path: '/privacyPolicy', builder: (context, state) => const PrivacyPolicyScreen())
]);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => LocaleProvider())],
        child: Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
          return MaterialApp.router(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: L10n.all,
              routerConfig: _router,
              debugShowCheckedModeBanner: false,
              locale: provider.locale);
        }));
  }
}
