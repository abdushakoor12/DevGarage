import 'package:flutter/material.dart';
import 'package:jayse/jayse.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class JsonViewerScreen extends StatefulWidget {
  const JsonViewerScreen({super.key});

  @override
  State<JsonViewerScreen> createState() => _JsonViewerScreenState();
}

class _JsonViewerScreenState extends State<JsonViewerScreen> {
  late final TextEditingController _controller = TextEditingController();

  JsonObject? jsonObject;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      try {
        jsonObject = jsonValueDecode(_controller.text) as JsonObject;
        setState(() {});
      } catch (e) {
        jsonObject = null;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ShadResizablePanelGroup(
        children: [
          ShadResizablePanel(
            defaultSize: .5,
            minSize: .2,
            maxSize: .8,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ShadInput(
                placeholder: Text('Paste JSON here'),
                controller: _controller,
                maxLines: null,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ),
          ShadResizablePanel(
            defaultSize: .5,
            minSize: .2,
            maxSize: .8,
            child: jsonObject == null
                ? const Center(child: Text('No JSON'))
                : Center(
                    child: Text(jsonObject!.fromPath(r'$').toString()),
                  ),
          ),
        ],
      ),
    );
  }
}
