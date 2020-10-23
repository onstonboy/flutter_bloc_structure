import 'package:equatable/equatable.dart';
import 'package:structure_flutter/data/source/local/database/local_database.dart';
import 'package:structure_flutter/data/source/remote/api/entities/user_remote_entity.dart';

class User extends Equatable {
  int id;
  String name;
  String avatar;

  User({
    this.id,
    this.name,
    this.avatar,
  });

  factory User.copyWithRemote(UserGitEntity entity) {
    return User(id: entity.id, name: entity.name, avatar: entity.avatar);
  }

  factory User.copyWithLocal(UserDB userDB) {
    return User(id: userDB.id, name: userDB.name, avatar: userDB.avatar);
  }
}
