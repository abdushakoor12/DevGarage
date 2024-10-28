import 'package:dev_garage/core/locator.dart';
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
    setUp(() {
      Locator.instance.clear();
    });

    test("should register and retrieve a service", () {
      Locator.instance.add<TestService>(() => TestService("test"));
      final service = Locator.instance.get<TestService>();
      expect(service, isA<TestService>());
      expect(service.value, "test");
    });

    test("should throw an exception if service is not found", () {
      expect(
          () => Locator.instance.get<TestService>(), throwsA(isA<Exception>()));
    });

    test("should register multiple services and retrieve them", () {
      Locator.instance.add<TestService>(() => TestService("test"));
      Locator.instance.add<TestServiceB>(() => TestServiceB("test"));
      final service = Locator.instance.get<TestService>();
      final serviceB = Locator.instance.get<TestServiceB>();
      expect(service, isA<TestService>());
      expect(service.value, "test");
      expect(serviceB, isA<TestServiceB>());
      expect(serviceB.value, "test");
    });

    test("should only register a service once when retrieved multiple times",
        () {
      int called = 0;
      Locator.instance.add<TestService>(() {
        called++;
        return TestService("test");
      });

      final service = Locator.instance.get<TestService>();
      final service2 = Locator.instance.get<TestService>();
      expect(service, same(service2));
      expect(called, 1);
    });

    test('should override an existing service with a new lazy initializer', () {
      Locator.instance.add<TestService>(() => TestService('Initial'));
      final initialService = Locator.instance.get<TestService>();
      expect(initialService.value, equals('Initial'));

      Locator.instance.override<TestService>(() => TestService('Overridden'));
      final overriddenService = Locator.instance.get<TestService>();

      expect(overriddenService.value, equals('Overridden'));
    });

    test('should clear all services and initializers', () {
      Locator.instance.add<TestService>(() => TestService('TestA'));
      Locator.instance.add<TestServiceB>(() => TestServiceB("123"));

      Locator.instance.get<TestService>();
      Locator.instance.get<TestServiceB>();

      Locator.instance.clear();

      expect(
        () => Locator.instance.get<TestService>(),
        throwsA(isA<Exception>()),
      );

      expect(
        () => Locator.instance.get<TestServiceB>(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
