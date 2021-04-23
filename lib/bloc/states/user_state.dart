import 'package:equatable/equatable.dart';
import 'package:structure_flutter/data/models/user.dart';

abstract class UserGitState extends Equatable {
  final List<Object> data;

  UserGitState({this.data = const []});

  @override
  List<Object> get props => data;
}

class UserGitUnInitialized extends UserGitState {
  @override
  String toString() => "UserGitUnInitialized";
}

class UserGitError extends UserGitState {
  @override
  String toString() => "UserGitError";
}

class UserGitLoaded extends UserGitState {
  final List<User> users;
  final bool hasReachMax;

  UserGitLoaded({this.users, this.hasReachMax}) : super(data: [users, hasReachMax]);

  UserGitLoaded copyWith({
    List<User> posts,
    bool hasReachedMax,
  }) {
    return UserGitLoaded(
      users: posts ?? this.users,
      hasReachMax: hasReachedMax ?? this.hasReachMax,
    );
  }

  @override
  String toString() => "UserGitLoaded";
}
