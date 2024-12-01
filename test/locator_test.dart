import 'package:dev_garage/core/locator.dart';
import 'package:dev_garage/core/locator_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestService {
  final String value;

  TestService(this.value);
}

class TestServiceB {
  final String value;

  TestServiceB(this.value);
}

void main() {
  group("Locator Tests", () {

    test("should register and retrieve a service", () {
      final locator = Locator();
      locator.add<TestService>(() => TestService("test"));
      final service = locator.get<TestService>();
      expect(service, isA<TestService>());
      expect(service.value, "test");
    });

    test("should throw an exception if service is not found", () {
      expect(() => Locator().get<TestService>(), throwsA(isA<Exception>()));
    });

    test("should register multiple services and retrieve them", () {
      final locator = Locator();
      locator.add<TestService>(() => TestService("test"));
      locator.add<TestServiceB>(() => TestServiceB("test"));
      final service = locator.get<TestService>();
      final serviceB = locator.get<TestServiceB>();
      expect(service, isA<TestService>());
      expect(service.value, "test");
      expect(serviceB, isA<TestServiceB>());
      expect(serviceB.value, "test");
    });

    test("should only register a service once when retrieved multiple times",
        () {
      final locator = Locator();
      int called = 0;
      locator.add<TestService>(() {
        called++;
        return TestService("test");
      });

      final service = locator.get<TestService>();
      final service2 = locator.get<TestService>();
      expect(service, same(service2));
      expect(called, 1);
    });

    test('should override an existing service with a new lazy initializer', () {
      final locator = Locator();
      locator.add<TestService>(() => TestService('Initial'));
      final initialService = locator.get<TestService>();
      expect(initialService.value, equals('Initial'));

      locator.override<TestService>(() => TestService('Overridden'));
      final overriddenService = locator.get<TestService>();

      expect(overriddenService.value, equals('Overridden'));
    });

    test('should clear all services and initializers', () {
      final locator = Locator();
      locator.add<TestService>(() => TestService('TestA'));
      locator.add<TestServiceB>(() => TestServiceB("123"));

      locator.get<TestService>();
      locator.get<TestServiceB>();

      locator.clear();

      expect(
        () => locator.get<TestService>(),
        throwsA(isA<Exception>()),
      );

      expect(
        () => locator.get<TestServiceB>(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group("Locator Root Tests", () {
    testWidgets(
        "should register and retrieve a service via context also for LocatorRoot inherited widget",
        (tester) async {
      final locator = Locator();
      locator.add<String>(() => "Injected Text");

      await tester.pumpWidget(LocatorRoot(
        locator: locator,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return Text(context.get<String>());
            }),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text("Injected Text"), findsOneWidget);
    });
  });
}
