import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

const kMinPasswordLength = 8;
const kMaxPasswordLength = 64;

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen>
    with SignalsMixin {
  late final length = createSignal(10);
  late final useUpperCase = createSignal(true);
  late final useLowerCase = createSignal(true);
  late final useNumber = createSignal(true);
  late final useSpecialCharacter = createSignal(true);

  late final password = createComputed(() => _generatePassword(
        length: length.value,
        useUpperCase: useUpperCase.value,
        useLowerCase: useLowerCase.value,
        useNumber: useNumber.value,
        useSpecialCharacter: useSpecialCharacter.value,
      ));

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
                  title: SelectableText(password.value,
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
                        Clipboard.setData(ClipboardData(text: password.value));
                      },
                      icon: const Icon(Icons.copy),
                    ),
                    IconButton(
                      onPressed: () {
                        password.recompute();
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
                        initialValue: length.value.toDouble(),
                        min: kMinPasswordLength.toDouble(),
                        max: kMaxPasswordLength.toDouble(),
                        onChanged: (value) {
                          length.value = value.round();
                        },
                      ),
                    ),
                    Text(kMaxPasswordLength.toString()),
                  ],
                ),
                const SizedBox(height: 16),
                ShadSwitch(
                  value: useUpperCase.value,
                  onChanged: (value) {
                    useUpperCase.value = value;
                  },
                  label: Text("Use Uppercase Letters"),
                ),
                ShadSwitch(
                  value: useNumber.value,
                  onChanged: (value) {
                    useNumber.value = value;
                  },
                  label: Text("Use Numbers"),
                ),
                ShadSwitch(
                  value: useSpecialCharacter.value,
                  onChanged: (value) {
                    useSpecialCharacter.value = value;
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
