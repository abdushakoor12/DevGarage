import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:dev_garage/core/locator_root.dart';
import 'package:dev_garage/core/theme_notifier.dart';
import 'package:dev_garage/features/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/locator.dart';
import 'features/json_viewer/json_viewer_screen.dart';
import 'features/passwod_generator/password_generator_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final locator = Locator();
  locator.add<ThemeNotifier>(() => ThemeNotifier(prefs));

  runApp(MyApp(
    locator: locator,
  ));
}

class MyApp extends StatefulWidget {
  final Locator locator;

  const MyApp({super.key, required this.locator});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) => BeamPage(
              title: 'Dev Garage',
              child: HomeScreen(),
            ),
        '/json_viewer': (context, state, data) => BeamPage(
              title: 'JSON Viewer',
              child: JsonViewerScreen(),
            ),
        '/password_generator': (context, state, data) => BeamPage(
              title: 'Password Generator',
              child: PasswordGeneratorScreen(),
            ),
      },
    ).call,
  );

  @override
  Widget build(BuildContext context) {
    return LocatorRoot(
      locator: widget.locator,
      child: ValueListenableBuilder(
        valueListenable: widget.locator.get<ThemeNotifier>(),
        builder: (context, themeMode, child) {
          return ShadApp.materialRouter(
              title: 'Dev Garage',
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              routerDelegate: routerDelegate,
              routeInformationParser: BeamerParser());
        },
      ),
    );
  }
}
