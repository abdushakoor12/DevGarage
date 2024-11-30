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

  // should be jsonObject or jsonArray
  JsonValue? rootValue;

  void _convert() {
    try {
      final parsed = jsonValueDecode(_controller.text);
      if(parsed is JsonObject || parsed is JsonArray) {
        rootValue = parsed;
      } else {
        rootValue = null;
      }
      setState(() {});
    } catch (e) {
      rootValue = null;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _convert();

    _controller.addListener(_convert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
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
            child: rootValue == null
                ? const Center(child: Text('No JSON'))
                : _JsonViewerView(rootValue: rootValue!),
          ),
        ],
      ),
    );
  }
}

class _JsonViewerView extends StatefulWidget {
  final JsonValue rootValue;

  const _JsonViewerView({required this.rootValue});

  @override
  State<_JsonViewerView> createState() => _JsonViewerViewState();
}

class _JsonViewerViewState extends State<_JsonViewerView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.rootValue is JsonObject || widget.rootValue is JsonArray);
    final value = widget.rootValue;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (value is JsonObject)
              for (var key in value.fields)
                _JsonValueView(
                  jsonValue: widget.rootValue.getValue(key),
                  name: key,
                ),
            if (value is JsonArray)
              for (var i = 0; i < value.arrayValue!.length; i++)
                _JsonValueView(
                  jsonValue: widget.rootValue.arrayValue![i],
                  name: i.toString(),
                ),
          ],
        ),
      ),
    );
  }
}

class _JsonValueView extends StatefulWidget {
  final JsonValue jsonValue;
  final String name;

  const _JsonValueView({required this.jsonValue, required this.name});

  @override
  State<_JsonValueView> createState() => _JsonValueViewState();
}

class _JsonValueViewState extends State<_JsonValueView> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            onTap: () {
              setState(() {
                if (widget.jsonValue is JsonObject ||
                    widget.jsonValue is JsonArray) {
                  expanded = !expanded;
                }
              });
            },
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: widget.name,
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '<'),
                  TextSpan(
                    text: widget.jsonValue.valueType,
                    style: TextStyle(color: Colors.green),
                  ),
                  TextSpan(text: '>'),
                  TextSpan(text: ' : '),
                  TextSpan(
                    text: widget.jsonValue.getKeyValue(),
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            )),
        if (expanded && widget.jsonValue is JsonObject)
          for (var key in widget.jsonValue.objectValue!.fields)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _JsonValueView(
                jsonValue: widget.jsonValue.objectValue!.getValue(key),
                name: key,
              ),
            ),
        if (expanded && widget.jsonValue is JsonArray)
          for (var i = 0; i < widget.jsonValue.arrayValue!.length; i++)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _JsonValueView(
                jsonValue: widget.jsonValue.arrayValue![i],
                name: i.toString(),
              ),
            ),
      ],
    );
  }
}

extension JsonValueExtensions on JsonValue {
  String get valueType => _getValueType(this);

  String getKeyValue() {
    return switch (this) {
      JsonObject() => "{...}",
      JsonArray() => "[...]",
      _ => toString(),
    };
  }
}

String _getValueType(JsonValue value) {
  return switch (value) {
    JsonString() => "string",
    JsonNumber() => "number",
    JsonBoolean() => "boolean",
    JsonArray() => "array",
    JsonObject() => "object",
    JsonNull() => "null",
    Undefined() => "undefined",
    WrongType() => "wrong type",
  };
}

const _testJson = r'''
{
  "user": {
    "id": 123,
    "name": "John Doe",
    "email": "johndoe@example.com",
    "isVerified": true,
    "preferences": {
      "theme": "dark",
      "notifications": {
        "email": true,
        "sms": false
      }
    }
  },
  "posts": [
    {
      "postId": 1,
      "title": "Hello World",
      "content": "This is a sample blog post.",
      "tags": ["welcome", "first-post"],
      "comments": [
        {
          "commentId": 101,
          "userId": 456,
          "comment": "Great post!",
          "timestamp": "2024-11-28T10:30:00Z"
        },
        {
          "commentId": 102,
          "userId": 789,
          "comment": "Thanks for sharing!",
          "timestamp": "2024-11-28T11:00:00Z"
        }
      ]
    },
    {
      "postId": 2,
      "title": "Advanced JSON Parsing",
      "content": "This post explains how to handle complex JSON.",
      "tags": ["json", "parsing"],
      "comments": []
    }
  ],
  "statistics": {
    "followers": 1200,
    "following": 150,
    "posts": 35
  },
  "active": true,
  "createdAt": "2020-05-15T14:48:00Z",
  "metadata": {
    "appVersion": "1.2.3",
    "apiVersion": "v2"
  }
}
''';
