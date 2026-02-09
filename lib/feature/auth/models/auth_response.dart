// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:car_rongsok_app/feature/user/models/user.dart';

class AuthResponse extends Equatable {
  final User user;
  final String token;

  const AuthResponse({required this.user, required this.token});

  AuthResponse copyWith({User? user, String? token}) {
    return AuthResponse(user: user ?? this.user, token: token ?? this.token);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'user': user.toMap(), 'token': token};
  }

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromJson(String source) =>
      AuthResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [user, token];
}
