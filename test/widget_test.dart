// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dev_garage/core/db/app_database.dart';
import 'package:dev_garage/core/locator.dart';
import 'package:dev_garage/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  late AppDatabase db;

  setUpAll(() async {
    setupDependencies();
    db = AppDatabase.memory();
    Locator.instance.override<AppDatabase>(() => db);
  });

  tearDownAll(() async {
    await db.close();
  });

  testWidgets('Notes get added into database', (WidgetTester tester) async {
    const testTitle = 'Test Title';
    const testUrl = 'https://www.google.com';

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text("Add Link"));
    await tester.pumpAndSettle();

    // verify that a dialog is shown
    expect(find.byType(ShadInputFormField), findsAtLeastNWidgets(2));

    // enter title and url
    await tester.enterText(find.byKey(Key("link_title_field")), testTitle);
    await tester.enterText(find.byKey(Key("link_url_field")), testUrl);
    await tester.tap(find.byKey(Key("add_link_button")));
    await tester.pumpAndSettle();

    expect(find.text(testTitle), findsOneWidget);
    expect(find.text(testUrl), findsOneWidget);
  });
}
