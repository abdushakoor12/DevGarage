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

  late final strength =
      createComputed(() => _calculateStrengthPercentage(password.value));

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
                Divider(),
                const SizedBox(height: 16),
                _passwordStrengthView(strength.value),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordStrengthView(double value) {
    final color = value < 0.5
        ? Colors.red
        : value < 0.75
            ? Colors.orange
            : Colors.green;
    final strengthText = value < 0.5
        ? "Weak"
        : value < 0.75
            ? "Medium"
            : "Strong";
    return ShadAlert(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          strengthText,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      description: LinearProgressIndicator(
        value: value,
        minHeight: 8,
        color: color,
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

/// Calculates the strength percentage of a password between 0-1.
double _calculateStrengthPercentage(String password) {
  if (password.isEmpty) return 0;

  int totalPoints = 6; // Total possible points
  int strengthPoints = 0;

  // Length criteria
  if (password.length >= 8) strengthPoints++;
  if (password.length >= 12) strengthPoints++;

  // Uppercase letter
  if (RegExp(r'[A-Z]').hasMatch(password)) strengthPoints++;

  // Lowercase letter
  if (RegExp(r'[a-z]').hasMatch(password)) strengthPoints++;

  // Number
  if (RegExp(r'\d').hasMatch(password)) strengthPoints++;

  // Special character
  if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strengthPoints++;

  // Common patterns (penalty)
  if (RegExp(r'(1234|password|qwerty|abc)').hasMatch(password)) {
    strengthPoints -= 2;
  }

  // Ensure the score is not negative
  strengthPoints = strengthPoints.clamp(0, totalPoints);

  // Calculate percentage
  return (strengthPoints / totalPoints);
}
