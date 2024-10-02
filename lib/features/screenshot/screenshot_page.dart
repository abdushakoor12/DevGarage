import 'dart:io';

import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';

class ScreenshotMakerPage extends StatefulWidget {
  const ScreenshotMakerPage({super.key});

  @override
  State<ScreenshotMakerPage> createState() => _ScreenshotMakerPageState();
}

class _ScreenshotMakerPageState extends State<ScreenshotMakerPage> {
  File? _pickedImage;

  bool dragging = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dragging ? Colors.grey : Colors.white,
      body: DropTarget(
        onDragDone: (details) {
          print(details.files.firstOrNull?.path);
          final file = details.files.firstOrNull;
          if (file == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No file selected'),
              ),
            );
            return;
          }

          final images = ["png", "jpg", "jpeg", "gif", "bmp", "webp", "heic"];

          if (images
              .any((value) => file.path.toLowerCase().contains(".$value"))) {
            setState(() {
              _pickedImage = File(file.path!);
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Not an image ${file.mimeType}'),
              ),
            );
          }
        },
        onDragEntered: (details) {
          setState(() {
            dragging = true;
          });
        },
        onDragExited: (details) {
          setState(() {
            dragging = false;
          });
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: _pickedImage == null
              ? const Center(
                  child: Text('Pick an image'),
                )
              : Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.green,
                        Colors.blue,
                        Colors.amber
                      ])
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.file(_pickedImage!))),
                ),
        ),
      ),
    );
  }
}
