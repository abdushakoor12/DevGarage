import 'package:dev_garage/features/link_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'json_viewer/json_viewer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LinkManagerScreen(),
                ));
              },
              child: ShadCard(
                title: Text("Link Manager"),
                description: Text("Manage your links"),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const JsonViewerScreen(),
                ));
              },
              child: ShadCard(
                title: Text("JSON Viewer"),
                description: Text("View JSON (Under construction)"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
