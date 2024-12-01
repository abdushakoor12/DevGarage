import 'package:dev_garage/core/locator.dart';
import 'package:dev_garage/core/theme_notifier.dart';
import 'package:dev_garage/features/json_viewer/json_viewer_screen.dart';
import 'package:dev_garage/features/passwod_generator/password_generator_screen.dart';
import 'package:dev_garage/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Locator locator;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    locator = Locator();
    locator.add<ThemeNotifier>(() => ThemeNotifier(prefs));
  });

  testWidgets('smoke test', (tester) async {
    await tester.pumpWidget(MyApp(locator: locator));
    await tester.pumpAndSettle();

    expect(find.byType(MyApp), findsOneWidget);
  });

  group("Navigation Tests", () {
    testWidgets("Navigate to Json Viewer Screen", (tester) async {
      await tester.pumpWidget(MyApp(locator: locator));
      await tester.pumpAndSettle();

      await tester.tap(find.text("JSON Viewer"));
      await tester.pumpAndSettle();

      expect(find.byType(JsonViewerScreen), findsOneWidget);
    });

    testWidgets("Navigate to Password Generator Screen", (tester) async {
      await tester.pumpWidget(MyApp(locator: locator));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Password Generator"));
      await tester.pumpAndSettle();

      expect(find.byType(PasswordGeneratorScreen), findsOneWidget);
    });
  });
}
