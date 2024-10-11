import 'package:dev_garage/features/link_manager/link_entity.dart';
import 'package:loon/loon.dart';

final linkEntityStore = Loon.collection<LinkEntity>(
  "link_entities",
  fromJson: LinkEntity.fromJson,
  toJson: (entity) => entity.toJson(),
);
