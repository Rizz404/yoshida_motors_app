// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:equatable/equatable.dart';

import 'package:car_rongsok_app/feature/user/models/user.dart';

class UpdateProfilePayload extends Equatable {
  final String? name;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? gender;
  final DateTime? birthDate;
  final String? fcmToken;

  const UpdateProfilePayload({
    this.name,
    this.phoneNumber,
    this.email,
    this.address,
    this.gender,
    this.birthDate,
    this.fcmToken,
  });

  bool get isEmpty =>
      name == null &&
      phoneNumber == null &&
      email == null &&
      address == null &&
      gender == null &&
      birthDate == null &&
      fcmToken == null;

  factory UpdateProfilePayload.fromChanges({
    required User original,
    String? name,
    String? phoneNumber,
    String? email,
    String? address,
    String? gender,
    DateTime? birthDate,
    String? fcmToken,
  }) {
    return UpdateProfilePayload(
      name: name != null && name != original.name ? name : null,
      phoneNumber: phoneNumber != null && phoneNumber != original.phoneNumber
          ? phoneNumber
          : null,
      email: email != null && email != original.email ? email : null,
      address: address != null && address != original.address ? address : null,
      gender: gender != null && gender != original.gender ? gender : null,
      birthDate: birthDate != null && birthDate != original.birthDate
          ? birthDate
          : null,
      fcmToken: fcmToken != null && fcmToken != original.fcmToken
          ? fcmToken
          : null,
    );
  }

  UpdateProfilePayload copyWith({
    String? name,
    String? phoneNumber,
    String? email,
    String? address,
    String? gender,
    DateTime? birthDate,
    String? fcmToken,
  }) {
    return UpdateProfilePayload(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (gender != null) 'gender': gender,
      if (birthDate != null)
        'birth_date':
            "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}",
      if (fcmToken != null) 'fcm_token': fcmToken,
    };
  }

  factory UpdateProfilePayload.fromMap(Map<String, dynamic> map) {
    return UpdateProfilePayload(
      name: map.getFieldOrNull<String>('name'),
      phoneNumber: map.getFieldOrNull<String>('phone_number'),
      email: map.getFieldOrNull<String>('email'),
      address: map.getFieldOrNull<String>('address'),
      gender: map.getFieldOrNull<String>('gender'),
      birthDate: map.getFieldOrNull<DateTime>('birth_date'),
      fcmToken: map.getFieldOrNull<String>('fcm_token'),
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateProfilePayload.fromJson(String source) =>
      UpdateProfilePayload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    name,
    phoneNumber,
    email,
    address,
    gender,
    birthDate,
    fcmToken,
  ];
}
