import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

const kMinPasswordLength = 8;
const kMaxPasswordLength = 64;

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  int length = 10;

  bool useUpperCase = true;
  bool useLowerCase = true;
  bool useNumber = true;
  bool useSpecialCharacter = true;

  String password = "";

  @override
  void initState() {
    _setPassword();

    super.initState();
  }

  void _setPassword() => password = _generatePassword(
        length: length,
        useUpperCase: useUpperCase,
        useLowerCase: useLowerCase,
        useNumber: useNumber,
        useSpecialCharacter: useSpecialCharacter,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Generator"),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ShadCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: SelectableText(password,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: password));
                      },
                      icon: const Icon(Icons.copy),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _setPassword();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text(kMinPasswordLength.toString()),
                    Expanded(
                      child: ShadSlider(
                        initialValue: length.toDouble(),
                        min: kMinPasswordLength.toDouble(),
                        max: kMaxPasswordLength.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            length = value.round();
                            _setPassword();
                          });
                        },
                      ),
                    ),
                    Text(kMaxPasswordLength.toString()),
                  ],
                ),
                const SizedBox(height: 16),
                ShadSwitch(
                  value: useUpperCase,
                  onChanged: (value) {
                    setState(() {
                      useUpperCase = value;
                      _setPassword();
                    });
                  },
                  label: Text("Use Uppercase Letters"),
                ),
                ShadSwitch(
                  value: useNumber,
                  onChanged: (value) {
                    setState(() {
                      useNumber = value;
                      _setPassword();
                    });
                  },
                  label: Text("Use Numbers"),
                ),
                ShadSwitch(
                  value: useSpecialCharacter,
                  onChanged: (value) {
                    setState(() {
                      useSpecialCharacter = value;
                      _setPassword();
                    });
                  },
                  label: Text("Use Special Characters"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _generatePassword({
  required int length,
  required bool useUpperCase,
  required bool useLowerCase,
  required bool useNumber,
  required bool useSpecialCharacter,
}) {
  final smallLetters = "abcdefghijklmnopqrstuvwxyz";
  final capitalLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final numbers = "0123456789";
  final specialCharacters = "!@#\$%^&*()_+-=[]{}|;:'\",./<>?";

  final random = Random();
  final password = StringBuffer();

  final listOfChars = [
    if (useUpperCase) capitalLetters,
    if (useLowerCase) smallLetters,
    if (useNumber) numbers,
    if (useSpecialCharacter) specialCharacters,
  ];

  for (var i = 0; i < length; i++) {
    final randomIndex = random.nextInt(listOfChars.length);
    password.write(listOfChars[randomIndex]
        [random.nextInt(listOfChars[randomIndex].length)]);
  }

  return password.toString();
}
