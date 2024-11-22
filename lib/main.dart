import 'package:dev_garage/core/locator_root.dart';
import 'package:dev_garage/features/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'core/db/app_database.dart';
import 'core/locator.dart';

final themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final locator = getLocator();

  runApp(MyApp(
    locator: locator,
  ));
}

Locator getLocator() {
  return Locator()..add<AppDatabase>(() => AppDatabase());
}

class MyApp extends StatelessWidget {
  final Locator locator;

  const MyApp({super.key, required this.locator});

  @override
  Widget build(BuildContext context) {
    return LocatorRoot(
      locator: locator,
      child: ValueListenableBuilder(
        valueListenable: themeNotifier,
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
