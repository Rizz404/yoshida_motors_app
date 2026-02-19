import 'dart:convert';

import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:equatable/equatable.dart';

class EmailRegisterPayload extends Equatable {
  final String idToken;
  final String? name;
  final String? address;
  final String? fcmToken;

  const EmailRegisterPayload({
    required this.idToken,
    this.name,
    this.address,
    this.fcmToken,
  });

  EmailRegisterPayload copyWith({
    String? idToken,
    String? name,
    String? address,
    String? fcmToken,
  }) {
    return EmailRegisterPayload(
      idToken: idToken ?? this.idToken,
      name: name ?? this.name,
      address: address ?? this.address,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_token': idToken,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (fcmToken != null) 'fcm_token': fcmToken,
    };
  }

  factory EmailRegisterPayload.fromMap(Map<String, dynamic> map) {
    return EmailRegisterPayload(
      idToken: map.getField<String>('id_token'),
      name: map.getFieldOrNull<String>('name'),
      address: map.getFieldOrNull<String>('address'),
      fcmToken: map.getFieldOrNull<String>('fcm_token'),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [idToken, name, address, fcmToken];
}
