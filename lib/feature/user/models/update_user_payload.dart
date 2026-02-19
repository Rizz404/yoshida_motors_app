// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:equatable/equatable.dart';

class UpdateUserPayload extends Equatable {
  final String? name;
  final String? email;
  final String? address;
  final String? fcmToken;

  const UpdateUserPayload({
    required this.name,
    required this.email,
    required this.address,
    required this.fcmToken,
  });

  UpdateUserPayload copyWith({
    String? name,
    String? email,
    String? address,
    String? fcmToken,
  }) {
    return UpdateUserPayload(
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'address': address,
      'fcmToken': fcmToken,
    };
  }

  factory UpdateUserPayload.fromMap(Map<String, dynamic> map) {
    return UpdateUserPayload(
      name: map.getFieldOrNull<String>('name'),
      email: map.getFieldOrNull<String>('email'),
      address: map.getFieldOrNull<String>('address'),
      fcmToken: map.getFieldOrNull<String>('fcmToken'),
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateUserPayload.fromJson(String source) =>
      UpdateUserPayload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name, email, address, fcmToken];
}
