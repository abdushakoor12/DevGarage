import 'package:dev_garage/core/db/app_database.dart';
import 'package:dev_garage/core/locator.dart';
import 'package:dev_garage/core/locator_root.dart';
import 'package:dev_garage/features/home_screen.dart';
import 'package:dev_garage/features/link_manager/link_manager_screen.dart';
import 'package:dev_garage/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  late AppDatabase db;
  late Locator locator;

  setUpAll(() async {
    locator = getLocator();
    db = AppDatabase.memory();
    locator.override<AppDatabase>(() => db);
  });

  tearDownAll(() async {
    await db.close();
  });

  testWidgets("Smoke Test", (tester) async {
    await tester.pumpWidget(MyApp(locator: locator));
    await tester.pumpAndSettle();

    final homeScreenFinder = find.byType(HomeScreen);

    expect(homeScreenFinder, findsOneWidget);
  });

  // this still fails for the dispose method in LinkManagerNotifier because of
  // fakeAsyncTimer
  testWidgets('Notes get added into database', (WidgetTester tester) async {
    const testTitle = 'Test Title';
    const testUrl = 'https://www.google.com';

    // Build our app and trigger a frame.
    await tester.pumpWidget(LocatorRoot(
        locator: locator, child: ShadApp.material(home: LinkManagerScreen())));

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
