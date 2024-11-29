import 'package:dev_garage/features/passwod_generator/password_generator_screen.dart';
import 'package:dev_garage/main.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'json_viewer/json_viewer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ShadButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: "Dev Garage",
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ShadButton(
              icon: Icon(
                themeNotifier.value == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                themeNotifier.value = themeNotifier.value == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const JsonViewerScreen(),
                ));
              },
              child: ShadCard(
                title: Text("JSON Viewer"),
                description: Text("View JSON"),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PasswordGeneratorScreen(),
                ));
              },
              child: ShadCard(
                title: Text("Password Generator"),
                description: Text("Generate passwords"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
