import 'dart:async';

import 'package:dev_garage/core/db/app_database.dart';
import 'package:dev_garage/core/locator.dart';
import 'package:flutter/material.dart';

class LinkManagerNotifier extends ChangeNotifier {
  final appDatabase = Locator().get<AppDatabase>();
  final searchController = TextEditingController();

  String _searchText = "";

  List<Link> _links = [];

  List<Link> get links => _links
      .where((e) =>
          e.title.toLowerCase().contains(_searchText.trim().toLowerCase()) ||
          e.url.toLowerCase().contains(_searchText.trim().toLowerCase()))
      .toList();

  List<LinkCategory> categories = [];

  final List<StreamSubscription> _subscriptions = [];

  LinkManagerNotifier() {
    _subscriptions.addAll(
      [
        appDatabase.select(appDatabase.links).watch().listen(
          (links) {
            _links = links;
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

    searchController.addListener(() {
      _searchText = searchController.text;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscriptions.forEach((e) => e.cancel());
    searchController.dispose();
    super.dispose();
  }
}
