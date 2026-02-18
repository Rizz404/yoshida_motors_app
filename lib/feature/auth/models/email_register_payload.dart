import 'dart:convert';

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

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [idToken, name, address, fcmToken];
}
