import 'package:dev_garage/core/locator_root.dart';
import 'package:dev_garage/core/theme_notifier.dart';
import 'package:dev_garage/features/passwod_generator/password_generator_screen.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'json_viewer/json_viewer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.get<ThemeNotifier>().value;
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
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: SegmentedButton(
              segments: ThemeMode.values
                  .map((e) => ButtonSegment(
                        value: e,
                        label: Icon(
                          switch (e) {
                            ThemeMode.light => Icons.light_mode,
                            ThemeMode.dark => Icons.dark_mode,
                            ThemeMode.system => Icons.brightness_auto,
                          },
                        ),
                      ))
                  .toList(),
              selected: {themeMode},
              onSelectionChanged: (value) {
                context.get<ThemeNotifier>().theme = value.first;
              },
            ),
          )
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
