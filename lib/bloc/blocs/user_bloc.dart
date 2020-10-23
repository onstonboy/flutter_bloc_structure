import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:structure_flutter/bloc/events/user_event.dart';
import 'package:structure_flutter/bloc/states/user_state.dart';
import 'package:structure_flutter/data/models/user.dart';
import 'package:structure_flutter/data/source/remote/result.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/repositories/user_repository.dart';

@singleton
class UserGitBloc extends Bloc<UserGitEvent, UserGitState> {
  final UserRepository _userRepository = getIt<UserRepository>();

  UserGitBloc();

  @override
  Stream<UserGitState> transform(Stream<UserGitEvent> events,
      Stream<UserGitState> Function(UserGitEvent event) next) {
    return super.transform(
        (events as Observable<UserGitEvent>)
            .debounceTime(Duration(milliseconds: 500)),
        next);
  }

  @override
  UserGitState get initialState => UserGitUnInitialized();

  @override
  Stream<UserGitState> mapEventToState(UserGitEvent event) async* {
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is UserGitUnInitialized) {
          await for (Result<List<User>> result in fetchUserGitNetworkBound(1)) {
            yield result.whenWithResult((success) {
              return UserGitLoaded(users: success.data, hasReachMax: false);
            }, (inProgress) {
              return UserGitLoaded(users: inProgress.data, hasReachMax: false);
            }, (error) {
              return UserGitError();
            });
          }
        } else if (currentState is UserGitLoaded) {
          var page =
              ((currentState as UserGitLoaded).users.length / 10).ceil() + 1;
          final users = await fetchUserGit(page);
          yield users.length < 10
              ? (currentState as UserGitLoaded).copyWith(hasReachedMax: true)
              : UserGitLoaded(
                  users: (currentState as UserGitLoaded).users + users,
                  hasReachMax: false);
        }
      } catch (_) {
        yield UserGitError();
      }
    }
  }

  bool _hasReachedMax(UserGitState state) =>
      state is UserGitLoaded && state.hasReachMax;

  Stream<Result<List<User>>> fetchUserGitNetworkBound(int page) {
    return _userRepository.getListUserNetworkBound(page);
  }

  Future<List<User>> fetchUserGit(int page) async {
    return _userRepository.getUser(page);
  }
}

Stream yieldDataSuccess(Success<List<User>> success) async* {
  yield UserGitLoaded(users: success.data, hasReachMax: false);
}

Stream yieldDataProgress(InProgress<List<User>> inProgress) async* {
  yield UserGitLoaded(users: inProgress.data, hasReachMax: false);
}

Stream yieldDataError(Error<List<User>> error) async* {
  yield UserGitError();
}
