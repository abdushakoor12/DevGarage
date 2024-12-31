import 'package:beamer/beamer.dart';
import 'package:dev_garage/core/locator_root.dart';
import 'package:dev_garage/core/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
                context.beamToNamed('/json_viewer');
              },
              child: ShadCard(
                title: Text("JSON Viewer"),
                description: Text("View JSON"),
              ),
            ),
            InkWell(
              onTap: () {
                context.beamToNamed('/password_generator');
              },
              child: ShadCard(
                title: Text("Password Generator"),
                description: Text("Generate passwords"),
              ),
            ),
            InkWell(
              onTap: () {
                context.beamToNamed('/hashing');
              },
              child: ShadCard(
                title: Text("Hashing"),
                description: Text("Generate hashes like MD5 SHA-256"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
