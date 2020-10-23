import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/models/user.dart';
import 'package:structure_flutter/data/source/remote/result.dart';
import 'package:structure_flutter/data/source/remote/user_remote_datasource.dart';

abstract class UserRepository {
  Future<List<User>> getUser(int page);
  Stream<Result<List<User>>> getListUserNetworkBound(int page);
}

@Singleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRepositoryImpl(this._userRemoteDataSource);

  @override
  Future<List<User>> getUser(int page) async {
    return _userRemoteDataSource.getUser(page);
  }

  @override
  Stream<Result<List<User>>> getListUserNetworkBound(int page) {
    return _userRemoteDataSource.getListUserNetworkBound(page);
  }
}
