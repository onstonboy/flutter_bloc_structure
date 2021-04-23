import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part '../parser/user_remote_entity.g.dart';

@JsonSerializable()
class UserGitEntity extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "login")
  final String name;
  @JsonKey(name: "avatar_url")
  final String avatar;

  UserGitEntity({this.id, this.name, this.avatar});

  factory UserGitEntity.fromJson(Map<String, dynamic> json) => _$UserGitFromJson(json);

  @override
  List<Object> get props => [id, name, avatar];

  Map<String, dynamic> toJson() => _$UserGitToJson(this);

  @override
  String toString() => 'UserGit { id: $id }';
}
