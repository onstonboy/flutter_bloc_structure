// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../entities/user_remote_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGitEntity _$UserGitFromJson(Map<String, dynamic> json) {
  return UserGitEntity(
    id: json['id'] as int,
    name: json['login'] as String,
    avatar: json['avatar_url'] as String,
  );
}

Map<String, dynamic> _$UserGitToJson(UserGitEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.name,
      'avatar_url': instance.avatar,
    };
