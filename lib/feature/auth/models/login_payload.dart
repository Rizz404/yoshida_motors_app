// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class LoginPayload extends Equatable {
  final String idToken;
  final String? fcmToken;

  const LoginPayload({required this.idToken, this.fcmToken});

  LoginPayload copyWith({String? idToken, String? fcmToken}) {
    return LoginPayload(
      idToken: idToken ?? this.idToken,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'idToken': idToken, 'fcmToken': fcmToken};
  }

  factory LoginPayload.fromMap(Map<String, dynamic> map) {
    return LoginPayload(
      idToken: map['idToken'] as String,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginPayload.fromJson(String source) =>
      LoginPayload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [idToken, fcmToken];
}
