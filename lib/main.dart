import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/bt_controller.dart';
import 'package:rover_app/l10n/l10n.dart';
import 'package:rover_app/l10n/locale_provider.dart';
import 'package:rover_app/providers/panels.dart';
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
      runApp(MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => BtController()),
        ChangeNotifierProvider(create: (_) => Panels())
      ], child: MainApp()));
    });
  });
}

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(path: '/', builder: (context, state) => DeviceListScreen()),
  GoRoute(
    path: '/controlScreen',
    builder: (context, state) => RoverControlScreen(),
  ),
  GoRoute(
      path: '/privacyPolicy',
      builder: (context, state) => const PrivacyPolicyScreen())
]);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => LocaleProvider())],
        child: Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
          return MaterialApp.router(
              theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: const ColorScheme(
                    brightness: Brightness.dark,
                    primary: Color(0xFFA5C8FF),
                    onPrimary: Color(0xFF00315F),
                    primaryContainer: Color(0xFF004786),
                    onPrimaryContainer: Color(0xFFD4E3FF),
                    secondary: Color(0xFFBCC7DC),
                    onSecondary: Color(0xFF273141),
                    secondaryContainer: Color(0xFF3D4758),
                    onSecondaryContainer: Color(0xFFD8E3F8),
                    tertiary: Color(0xFFA1C9FF),
                    onTertiary: Color(0xFF00325B),
                    tertiaryContainer: Color(0xFF004880),
                    onTertiaryContainer: Color(0xFFD2E4FF),
                    error: Color(0xFFFFB4AB),
                    errorContainer: Color(0xFF93000A),
                    onError: Color(0xFF690005),
                    onErrorContainer: Color(0xFFFFDAD6),
                    background: Color(0xFF1A1C1E),
                    onBackground: Color(0xFFE3E2E6),
                    surface: Color(0xFF1A1C1E),
                    onSurface: Color(0xFFE3E2E6),
                    surfaceVariant: Color(0xFF43474E),
                    onSurfaceVariant: Color(0xFFC3C6CF),
                    outline: Color(0xFF8D9199),
                    onInverseSurface: Color(0xFF1A1C1E),
                    inverseSurface: Color(0xFFE3E2E6),
                    inversePrimary: Color(0xFF1E5FA6),
                    shadow: Color(0xFF000000),
                    surfaceTint: Color(0xFFA5C8FF),
                    outlineVariant: Color(0xFF43474E),
                    scrim: Color(0xFF000000),
                  )),
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
