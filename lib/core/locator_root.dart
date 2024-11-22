import 'package:dev_garage/core/locator.dart';
import 'package:flutter/material.dart';

class LocatorRoot extends InheritedWidget {
  final Locator locator;

  const LocatorRoot({
    super.key,
    required super.child,
    required this.locator,
  });

  static Locator of(BuildContext context) {
    final l =
        context.dependOnInheritedWidgetOfExactType<LocatorRoot>()?.locator;
    if (l == null) throw Exception("Locator not found");
    return l;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

extension LocatorRootExtensions on BuildContext {
  Locator get locator => LocatorRoot.of(this);

  T get<T>() => locator.get<T>();
}
