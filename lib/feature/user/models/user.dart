// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:car_rongsok_app/core/enums/model_entity_enums.dart';
import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firebaseUid;
  final String? phoneNumber;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? address;
  final String? gender;
  final DateTime? birthDate;
  final AuthProvider? authProvider;
  final UserRole role;
  final String? fcmToken;
  final String? profilePhoto;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.firebaseUid,
    required this.phoneNumber,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.address,
    this.gender,
    this.birthDate,
    this.authProvider,
    required this.role,
    required this.fcmToken,
    this.profilePhoto,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    int? id,
    String? firebaseUid,
    String? phoneNumber,
    String? name,
    String? email,
    DateTime? emailVerifiedAt,
    String? address,
    String? gender,
    DateTime? birthDate,
    AuthProvider? authProvider,
    UserRole? role,
    String? fcmToken,
    String? profilePhoto,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      authProvider: authProvider ?? this.authProvider,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firebase_uid': firebaseUid,
      'phone_number': phoneNumber,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'address': address,
      'gender': gender,
      'birth_date': birthDate != null
          ? "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}"
          : null,
      'auth_provider': authProvider?.value,
      'role': role.value,
      'fcm_token': fcmToken,
      'profile_photo': profilePhoto,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map.getField<int>('id'),
      firebaseUid: map.getField<String>('firebase_uid'),
      phoneNumber: map.getFieldOrNull<String>('phone_number'),
      name: map.getFieldOrNull<String>('name'),
      email: map.getFieldOrNull<String>('email'),
      emailVerifiedAt: map.getFieldOrNull<DateTime>('email_verified_at'),
      address: map.getFieldOrNull<String>('address'),
      gender: map.getFieldOrNull<String>('gender'),
      birthDate: map.getFieldOrNull<DateTime>('birth_date'),
      authProvider: map['auth_provider'] != null
          ? AuthProvider.values.firstWhere(
              (e) => e.value == map['auth_provider'],
              orElse: () => AuthProvider.email,
            )
          : null,
      role: UserRole.values.firstWhere((e) => e.value == map['role']),
      fcmToken: map.getFieldOrNull<String>('fcm_token'),
      profilePhoto: map.getFieldOrNull<String>('profile_photo'),
      createdAt: map.getField<DateTime>('created_at'),
      updatedAt: map.getField<DateTime>('updated_at'),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      firebaseUid,
      phoneNumber,
      name,
      email,
      emailVerifiedAt,
      address,
      gender,
      birthDate,
      authProvider,
      role,
      fcmToken,
      profilePhoto,
      createdAt,
      updatedAt,
    ];
  }
}
