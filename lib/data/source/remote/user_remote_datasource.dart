import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/models/user.dart';
import 'package:structure_flutter/data/source/local/database/local_database.dart';
import 'package:structure_flutter/data/source/remote/api/response/user_git_response.dart';
import 'package:structure_flutter/data/source/remote/network_bound_resource.dart';
import 'package:structure_flutter/data/source/remote/result.dart';
import 'package:structure_flutter/data/source/remote/service/dio_client.dart';

abstract class UserRemoteDataSource {
  Future<List<User>> getUser(int page);

  // Network Bound Region
  Stream<Result<List<User>>> getListUserNetworkBound(int page);
}

@Singleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _dioClient;
  final LocalDatabase _localDatabase;

  UserRemoteDataSourceImpl(this._dioClient, this._localDatabase);

  @override
  Future<List<User>> getUser(int page) async {
    final response = await _dioClient.get('/search/users',
        queryParameters: {'q': 'abc', 'page': page, 'per_page': 10});
    var users = UserGitResponse.fromJson(response)
        .userGits
        .map((entity) => User.copyWithRemote(entity))
        .toList();
    await _localDatabase.userDao.insertUsers(users);
    return users;
  }

  @override
  Stream<Result<List<User>>> getListUserNetworkBound(int page) {
    return NetworkBoundResource<List<User>, List<User>>().asStream(
      loadFromDb: () => _localDatabase.userDao.getAllUsers,
      createCall: () => getUser(page),
      saveCallResult: (result) => _localDatabase.userDao.insertUsers(result),
    );
  }
}
