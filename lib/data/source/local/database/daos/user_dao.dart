import 'package:moor/moor.dart';
import 'package:structure_flutter/data/models/user.dart';
import 'package:structure_flutter/data/source/local/database/entities/user_local_entity.dart';

import '../local_database.dart';

part 'user_dao.g.dart';

@UseDao(tables: [UserLocalEntities])
class UserDao extends DatabaseAccessor<LocalDatabase> with _$UserDaoMixin {
  UserDao(LocalDatabase attachedDatabase) : super(attachedDatabase);

  Future<List<User>> get getAllUsers => select(userLocalEntity)
      .map((userDB) => User.copyWithLocal(userDB))
      .get();

  Stream<List<User>> get allUsersStream => select(userLocalEntity)
      .map((userDB) => User.copyWithLocal(userDB))
      .watch();

  Future<dynamic> insertUsers(List<User> users) {
    var userEntities = users
        .map((user) => UserLocalEntityCompanion.insert(
            id: Value(user.id), name: user.name, avatar: user.avatar))
        .toList();
    return batch((batch) {
      batch.insertAllOnConflictUpdate(userLocalEntity, userEntities);
    });
  }
}
