// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UpdateProfilePayload extends Equatable {
  final String? name;
  final String? email;
  final String? address;
  final String? fcmToken;

  const UpdateProfilePayload({
    this.name,
    this.email,
    this.address,
    this.fcmToken,
  });

  UpdateProfilePayload copyWith({
    String? name,
    String? email,
    String? address,
    String? fcmToken,
  }) {
    return UpdateProfilePayload(
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (fcmToken != null) 'fcm_token': fcmToken,
    };
  }

  factory UpdateProfilePayload.fromMap(Map<String, dynamic> map) {
    return UpdateProfilePayload(
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      fcmToken: map['fcm_token'] != null ? map['fcm_token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateProfilePayload.fromJson(String source) =>
      UpdateProfilePayload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name, email, address, fcmToken];
}
