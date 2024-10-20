import 'dart:async';

import 'package:dev_garage/core/db/app_database.dart';
import 'package:dev_garage/core/locator.dart';
import 'package:flutter/material.dart';

class LinkManagerNotifier extends ChangeNotifier {
  final appDatabase = locator.get<AppDatabase>();

  List<Link> links = [];
  List<LinkCategory> categories = [];

  final List<StreamSubscription> _subscriptions = [];

  LinkManagerNotifier() {
    _subscriptions.addAll(
      [
        appDatabase.select(appDatabase.links).watch().listen(
          (links) {
            this.links = links;
            notifyListeners();
          },
        ),
        appDatabase.select(appDatabase.linkCategories).watch().listen(
          (categories) {
            this.categories = categories;
            notifyListeners();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _subscriptions.forEach((e) => e.cancel());
    super.dispose();
  }
}
