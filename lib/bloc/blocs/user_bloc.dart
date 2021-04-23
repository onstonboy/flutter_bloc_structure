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

  UserGitBloc() : super(UserGitUnInitialized());

  @override
  Stream<Transition<UserGitEvent, UserGitState>> transformEvents(Stream<UserGitEvent> events, transitionFn) {
    return events.debounceTime(const Duration(milliseconds: 500)).switchMap((transitionFn));
  }

  @override
  Stream<UserGitState> mapEventToState(UserGitEvent event) async* {
    if (event is Fetch && !_hasReachedMax(state)) {
      try {
        if (state is UserGitUnInitialized) {
          await for (Result<List<User>> result in fetchUserGitNetworkBound(1)) {
            yield result.whenWithResult((success) {
              return UserGitLoaded(users: success.data, hasReachMax: false);
            }, (inProgress) {
              return UserGitLoaded(users: inProgress.data, hasReachMax: false);
            }, (error) {
              return UserGitError();
            });
          }
        } else if (state is UserGitLoaded) {
          var page = ((state as UserGitLoaded).users.length / 10).ceil() + 1;
          final users = await fetchUserGit(page);
          yield users.length < 10
              ? (state as UserGitLoaded).copyWith(hasReachedMax: true)
              : UserGitLoaded(users: (state as UserGitLoaded).users + users, hasReachMax: false);
        }
      } catch (_) {
        yield UserGitError();
      }
    }
  }

  bool _hasReachedMax(UserGitState state) => state is UserGitLoaded && state.hasReachMax;

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
