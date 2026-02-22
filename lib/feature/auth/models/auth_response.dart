// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:car_rongsok_app/feature/user/models/user.dart';
import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final User user;
  final String token;
  final bool isNewUser;

  const AuthResponse({
    required this.user,
    required this.token,
    this.isNewUser = false,
  });

  AuthResponse copyWith({User? user, String? token, bool? isNewUser}) {
    return AuthResponse(
      user: user ?? this.user,
      token: token ?? this.token,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'token': token,
      'is_new_user': isNewUser,
    };
  }

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      user: User.fromMap(map.getField<Map<String, dynamic>>('user')),
      token: map.getField<String>('token'),
      isNewUser: map.getFieldOrNull<bool>('is_new_user') ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromJson(String source) =>
      AuthResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [user, token, isNewUser];
}
