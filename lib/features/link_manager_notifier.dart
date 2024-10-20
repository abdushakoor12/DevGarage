import 'dart:async';

import 'package:dev_garage/core/db/app_database.dart';
import 'package:dev_garage/core/locator.dart';
import 'package:flutter/material.dart';

class LinkManagerNotifier extends ChangeNotifier {
  final appDatabase = locator.get<AppDatabase>();

  List<Link> links = [];

  StreamSubscription? _subscription;

  LinkManagerNotifier() {
    _subscription = appDatabase.select(appDatabase.links).watch().listen((links) {
      this.links = links;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
