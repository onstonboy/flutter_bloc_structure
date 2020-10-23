import 'package:moor/moor.dart';

@DataClassName('UserDB')
class UserLocalEntities extends Table {
  IntColumn get id => integer().named('id')();
  TextColumn get name => text().named('name')();
  TextColumn get avatar => text().named('avatar')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => "users";
}
