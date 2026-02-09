import 'dart:convert';

import 'package:equatable/equatable.dart';

class RegisterPayload extends Equatable {
  final String idToken;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? address;
  final String? fcmToken;

  const RegisterPayload({
    required this.idToken,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.address,
    required this.fcmToken,
  });

  RegisterPayload copyWith({
    String? idToken,
    String? phoneNumber,
    String? name,
    String? email,
    String? address,
    String? fcmToken,
  }) {
    return RegisterPayload(
      idToken: idToken ?? this.idToken,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idToken': idToken,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'address': address,
      'fcmToken': fcmToken,
    };
  }

  factory RegisterPayload.fromMap(Map<String, dynamic> map) {
    return RegisterPayload(
      idToken: map['idToken'] as String,
      phoneNumber: map['phoneNumber'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterPayload.fromJson(String source) =>
      RegisterPayload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [idToken, phoneNumber, name, email, address, fcmToken];
  }
}
