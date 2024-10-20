import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final themeNotifier = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return ShadApp.material(
          title: 'Dev Garage',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          home: Scaffold(
            appBar: AppBar(
              title: const Text("Dev Garage"),
              actions: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 120),
                  child: ShadSelect<ThemeMode>(
                    placeholder: Text(themeMode.name),
                    options: [
                      ...ThemeMode.values.map((e) => ShadOption(
                            value: e,
                            child: Text(e.name),
                          )),
                    ],
                    selectedOptionBuilder: (context, value) {
                      return Text(value.name);
                    },
                    onChanged: (value) {
                      themeNotifier.value = value;
                    },
                  ),
                )
              ],
            ),
            body: Center(
              child: ShadButton(
                child: Text("Hello"),
              ),
            ),
          ),
        );
      },
    );
  }
}
