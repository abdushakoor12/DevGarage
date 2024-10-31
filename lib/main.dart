import 'package:dev_garage/features/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'core/db/app_database.dart';
import 'core/locator.dart';
import 'features/link_manager_notifier.dart';

final themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencies();

  runApp(const MyApp());
}

void setupDependencies() {
  Locator.instance
    ..add<AppDatabase>(() => AppDatabase())
    ..add<LinkManagerNotifier>(() => LinkManagerNotifier());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return ShadApp.material(
          title: 'Dev Garage',
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
      },
    );
  }
}
