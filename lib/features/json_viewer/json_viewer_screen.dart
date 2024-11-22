import 'package:flutter/material.dart';
import 'package:jayse/jayse.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class JsonViewerScreen extends StatefulWidget {
  const JsonViewerScreen({super.key});

  @override
  State<JsonViewerScreen> createState() => _JsonViewerScreenState();
}

class _JsonViewerScreenState extends State<JsonViewerScreen> {
  late final TextEditingController _controller = TextEditingController(
    text: _testJson,
  );

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
                : _JsonViewerView(jsonObject: jsonObject!),
          ),
        ],
      ),
    );
  }
}

class _JsonViewerView extends StatefulWidget {
  final JsonObject jsonObject;

  const _JsonViewerView({super.key, required this.jsonObject});

  @override
  State<_JsonViewerView> createState() => _JsonViewerViewState();
}

class _JsonViewerViewState extends State<_JsonViewerView> {
  late final keys = widget.jsonObject.fields;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var key in keys)
              Text("$key<${widget.jsonObject.getValue(key).runtimeType}>"),
          ],
        ),
      ),
    );
  }
}

const _testJson = r'''
{
    "userId": 1,
    "id": 1,
    "title": "delectus aut autem",
    "completed": false
  }
  ''';
