import 'package:dev_garage/features/link_manager/link_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:loon/loon.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Loon.configure(persistor: FilePersistor());

  await Loon.hydrate();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dev Garage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LinkManagerScreen(),
    );
  }
}
