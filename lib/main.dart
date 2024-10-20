import 'package:dev_garage/features/link_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
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
            home: LinkManagerScreen(),
          );
        });
  }
}
