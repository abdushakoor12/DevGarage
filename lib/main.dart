import 'dart:async';

import 'package:dev_garage/core/locator_root.dart';
import 'package:dev_garage/core/theme_notifier.dart';
import 'package:dev_garage/features/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final locator = Locator();
  locator.add<ThemeNotifier>(() => ThemeNotifier(prefs));

  runApp(MyApp(
    locator: locator,
  ));
}

class MyApp extends StatelessWidget {
  final Locator locator;

  const MyApp({super.key, required this.locator});

  @override
  Widget build(BuildContext context) {
    return LocatorRoot(
      locator: locator,
      child: ValueListenableBuilder(
        valueListenable: locator.get<ThemeNotifier>(),
        builder: (context, themeMode, child) {
          return ShadApp.material(
            title: 'Dev Garage',
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
