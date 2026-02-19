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
  final String? address;
  final UserRole role;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.firebaseUid,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.address,
    required this.role,
    required this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    int? id,
    String? firebaseUid,
    String? phoneNumber,
    String? name,
    String? email,
    String? address,
    UserRole? role,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
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
      'address': address,
      'role': role.value,
      'fcm_token': fcmToken,
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
      address: map.getFieldOrNull<String>('address'),
      role: UserRole.values.firstWhere((e) => e.value == map['role']),
      fcmToken: map.getFieldOrNull<String>('fcm_token'),
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
      address,
      role,
      fcmToken,
      createdAt,
      updatedAt,
    ];
  }
}
