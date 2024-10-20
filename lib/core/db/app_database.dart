import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

@DataClassName('LinkCategory')
class LinkCategories extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v4())(); // UUID as primary key
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LinkTag')
class LinkTags extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v4())(); // UUID as primary key
  TextColumn get name => text().withLength(min: 1, max: 50)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Link')
class Links extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v4())(); // UUID as primary key
  TextColumn get categoryId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get url => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LinkTagConnection')
class LinkTagConnections extends Table {
  TextColumn get linkId => text()();
  TextColumn get tagId => text()();

  @override
  Set<Column> get primaryKey => {linkId, tagId};
}

@DriftDatabase(tables: [
  LinkCategories,
  LinkTags,
  Links,
  LinkTagConnections
])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a schemaVersion getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/getting-started/#open
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // driftDatabase from package:drift_flutter stores the database in
    // getApplicationDocumentsDirectory().
    return driftDatabase(name: 'my_database');
  }
}
