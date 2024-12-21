import 'dart:convert';

import 'package:arborio/tree_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jayse/jayse.dart';
import 'package:jayse/parser.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide TreeView;
import 'package:signals/signals_flutter.dart';

class JsonViewerScreen extends StatefulWidget {
  const JsonViewerScreen({super.key});

  @override
  State<JsonViewerScreen> createState() => _JsonViewerScreenState();
}

class _JsonViewerScreenState extends State<JsonViewerScreen> with SignalsMixin {
  late final TextEditingController _controller =
      TextEditingController(text: kDebugMode ? _testJson : "");
  late final TextEditingController _pathController = TextEditingController();

  late final textEditingValue = _controller.toSignal();
  late final pathEditingValue = _pathController.toSignal();

  late final Computed<JsonValue?> rootValue = createComputed(() {
    try {
      final parsed = jsonValueDecode(textEditingValue.value.text);
      if (parsed is JsonObject || parsed is JsonArray) {
        return parsed;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  });

  late final filteredJsonValue = createComputed(() {
    final rootValue = this.rootValue.value;
    if (rootValue == null) {
      return null;
    } else {
      try {
        final parsed = parseJsonPath(pathEditingValue.value.text, rootValue);
        return parsed;
      } catch (e) {
        return null;
      }
    }
  });

  late final Computed<List<TreeNode<JsonValueKeyPair>>> jsonTree =
      createComputed(
    () {
      final jsonValue = filteredJsonValue.value ?? rootValue.value;
      if (jsonValue == null) {
        return [];
      }

      return _getTree(jsonValue);
    },
  );

  @override
  Widget build(BuildContext context) {
    final invalidPath = pathEditingValue.value.text.trim().isNotEmpty &&
        filteredJsonValue.value == null;
    final border = invalidPath
        ? ShadBorder.all(color: ShadTheme.of(context).colorScheme.destructive)
        : null;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (rootValue.value != null)
              ShadButton(
                icon: const Icon(Icons.format_indent_increase),
                child: Text("Format"),
                onPressed: () {
                  JsonEncoder encoder = JsonEncoder.withIndent('  ');
                  setState(() {
                    _controller.text = encoder.convert(rootValue.value);
                  });
                },
              )
          ],
        ),
        actions: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: ShadInput(
              controller: _pathController,
              decoration: ShadDecoration(
                border: border,
              ),
              placeholder: Text('Search path e.g. \$.books'),
            ),
          )
        ],
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
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: jsonTree.value.isEmpty
                  ? const Center(child: Text('No JSON'))
                  : TreeView(
                      nodes: jsonTree.value,
                      animationDuration: const Duration(milliseconds: 200),
                      expanderBuilder: (context, isExpanded, animation) =>
                          RotationTransition(
                        turns: animation,
                        child: const Icon(Icons.arrow_right),
                      ),
                      indentation: SizedBox(width: 8),
                      builder: (BuildContext context,
                          TreeNode<JsonValueKeyPair> node,
                          bool isSelected,
                          Animation<double> expansionAnimation,
                          void Function(TreeNode<JsonValueKeyPair>) select) {
                        return RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                text: node.data.key,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '<'),
                              TextSpan(
                                text: node.data.value.valueType,
                                style: TextStyle(color: Colors.green),
                              ),
                              TextSpan(text: '>'),
                              TextSpan(text: ' : '),
                              TextSpan(
                                text: node.data.value.getKeyValue(),
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  List<TreeNode<JsonValueKeyPair>> _getTree(JsonValue jsonValue) {
    final List<TreeNode<JsonValueKeyPair>> nodes =
        <TreeNode<JsonValueKeyPair>>[];
    if (jsonValue is JsonObject || jsonValue is JsonArray) {
      nodes.addAll(
        getNodes(jsonValue),
      );
    } else {
      nodes.add(
        TreeNode(
          Key(jsonValue.getKeyValue()),
          (key: jsonValue.getKeyValue(), value: jsonValue),
        ),
      );
    }

    return nodes;
  }
}

List<TreeNode<JsonValueKeyPair>> getNodes(JsonValue jsonValue) {
  assert(jsonValue is JsonObject || jsonValue is JsonArray);

  final List<TreeNode<JsonValueKeyPair>> nodes = [];

  if (jsonValue is JsonObject) {
    for (final key in jsonValue.fields) {
      final value = jsonValue.getValue(key);

      nodes.add(TreeNode(
        Key(key),
        (key: key, value: value),
        value is JsonObject || value is JsonArray ? getNodes(value) : null,
      ));
    }
  }

  if (jsonValue is JsonArray) {
    for (var i = 0; i < jsonValue.arrayValue!.length; i++) {
      final value = jsonValue.arrayValue![i];

      nodes.add(TreeNode(
          Key(i.toString()),
          (key: i.toString(), value: jsonValue.arrayValue![i]),
          value is JsonObject || value is JsonArray ? getNodes(value) : null));
    }
  }

  return nodes;
}

typedef JsonValueKeyPair = ({String key, JsonValue value});

extension JsonValueExtensions on JsonValue {
  String get valueType => _getValueType(this);

  String getKeyValue() {
    return switch (this) {
      (final JsonObject jsonObject) =>
        "{${jsonObject.fields.isEmpty ? "empty" : "${jsonObject.fields.length}"}}",
      (final JsonArray jsonArray) =>
        "[${jsonArray.arrayValue!.isEmpty ? "empty" : "${jsonArray.arrayValue!.length}"}]",
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
