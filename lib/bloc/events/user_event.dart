abstract class UserGitEvent {}

class Fetch extends UserGitEvent {
  @override
  String toString() => "fetch";
}
