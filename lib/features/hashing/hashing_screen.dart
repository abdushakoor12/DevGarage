import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';

class HashingScreen extends StatefulWidget {
  const HashingScreen({super.key});

  @override
  State<HashingScreen> createState() => _HashingScreenState();
}

class _HashingScreenState extends State<HashingScreen> with SignalsMixin {
  late final valueController = TextEditingController();
  late final textValue = valueController.toSignal();

  late final Computed<Map<_HashedValue, String>> _hashes = createComputed(() {
    final value = textValue.value.text;
    if (value.isEmpty) return {};
    final bytes = utf8.encode(value);
  
    return {
      _HashedValue.md5: md5.convert(bytes).toString(),
      _HashedValue.sha1: sha1.convert(bytes).toString(),
      _HashedValue.sha224: sha224.convert(bytes).toString(),
      _HashedValue.sha256: sha256.convert(bytes).toString(),
      _HashedValue.sha384: sha384.convert(bytes).toString(),
      _HashedValue.sha512: sha512.convert(bytes).toString(),
    };
  });

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hashing"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              ShadInput(
                placeholder: Text("Enter text to hash"),
                controller: valueController,
              ),
              const SizedBox(height: 20),
              if (_hashes.value.isNotEmpty)
                for (final hash in _hashes.value.entries)
                  ListTile(
                    title: Text(hash.key.label),
                    subtitle: Text(hash.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: hash.value));
                      },
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}

enum _HashedValue {
  md5,
  sha1,
  sha224,
  sha256,
  sha384,
  sha512;

  String get label {
    return switch (this) {
      _HashedValue.md5 => "MD5",
      _HashedValue.sha1 => "SHA-1",
      _HashedValue.sha224 => "SHA-224",
      _HashedValue.sha256 => "SHA-256",
      _HashedValue.sha384 => "SHA-384",
      _HashedValue.sha512 => "SHA-512",
    };
  }
}
