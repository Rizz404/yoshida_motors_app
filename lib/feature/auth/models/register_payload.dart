import 'dart:convert';

import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
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
      'id_token': idToken,
      'phone_number': phoneNumber,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (fcmToken != null) 'fcm_token': fcmToken,
    };
  }

  factory RegisterPayload.fromMap(Map<String, dynamic> map) {
    return RegisterPayload(
      idToken: map.getField<String>('idToken'),
      phoneNumber: map.getField<String>('phoneNumber'),
      name: map.getFieldOrNull<String>('name'),
      email: map.getFieldOrNull<String>('email'),
      address: map.getFieldOrNull<String>('address'),
      fcmToken: map.getFieldOrNull<String>('fcmToken'),
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
