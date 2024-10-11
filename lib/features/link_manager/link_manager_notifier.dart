import 'dart:async';

import 'package:dev_garage/features/link_manager/link_entity.dart';
import 'package:dev_garage/features/link_manager/link_stores.dart';
import 'package:flutter/material.dart';

final linkManagerNotifier = LinkManagerNotifier();

class LinkManagerNotifier extends ChangeNotifier {
  List<LinkEntity> _linkEntities = [];
  List<LinkEntity> get linkEntities => _linkEntities;

  late StreamSubscription _subscription;

  LinkManagerNotifier() {
    _subscription = linkEntityStore.stream().listen((links) {
      _linkEntities = links.map((e) => e.data).toList();
      notifyListeners();
    });

    // final test = LinkEntity(
    //   name: "test",
    //   url: "https://www.google.com",
    //   id: 'dsadas',
    //   tags: ['test'],
    //   createdAt: DateTime.now(),
    // );

    // linkEntityStore.doc(test.id).createOrUpdate(test);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
