import 'package:dev_garage/features/link_manager/link_manager_notifier.dart';
import 'package:flutter/material.dart';

class LinkManagerScreen extends StatelessWidget {
  const LinkManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      builder: (context, child) {
        return Scaffold(
          body: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.red,
                ),
              ),
              Expanded(
                flex: 4,
                child: ListView(
                  children: [
                    ...linkManagerNotifier.linkEntities.map((e) {
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          onTap: () {},
                          title: Text(e.name),
                          subtitle: Text(e.url),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            label: Text("Add Link"),
            icon: const Icon(Icons.add),
          ),
        );
      },
      listenable: linkManagerNotifier,
    );
  }
}
