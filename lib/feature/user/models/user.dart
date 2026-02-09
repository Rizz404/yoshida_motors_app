// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firebaseUid;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? address;
  final String role;
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
    String? role,
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
      'firebaseUid': firebaseUid,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'address': address,
      'role': role,
      'fcmToken': fcmToken,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      firebaseUid: map['firebaseUid'] as String,
      phoneNumber: map['phoneNumber'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      role: map['role'] as String,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
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
