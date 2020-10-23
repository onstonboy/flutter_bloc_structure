import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:structure_flutter/data/source/local/database/daos/user_dao.dart';
import 'package:structure_flutter/data/source/local/database/entities/user_local_entity.dart';
part 'local_database.g.dart';

@UseMoor(tables: [UserLocalEntities], daos: [UserDao])
class LocalDatabase extends _$LocalDatabase {

  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'structure_flutter.db.sqlite'));
    return VmDatabase(file);
  });
}
