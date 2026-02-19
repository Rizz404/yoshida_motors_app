// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:equatable/equatable.dart';

class CreateAppraisalPayload extends Equatable {
  final String vehicleBrand;
  final String vehicleModel;
  final int yearManufacture;
  final String? description;

  const CreateAppraisalPayload({
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.yearManufacture,
    this.description,
  });

  CreateAppraisalPayload copyWith({
    String? vehicleBrand,
    String? vehicleModel,
    int? yearManufacture,
    String? description,
  }) {
    return CreateAppraisalPayload(
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      yearManufacture: yearManufacture ?? this.yearManufacture,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'vehicle_brand': vehicleBrand,
      'vehicle_model': vehicleModel,
      'year_manufacture': yearManufacture,
      if (description != null) 'description': description,
    };
  }

  factory CreateAppraisalPayload.fromMap(Map<String, dynamic> map) {
    return CreateAppraisalPayload(
      vehicleBrand: map.getField<String>('vehicle_brand'),
      vehicleModel: map.getField<String>('vehicle_model'),
      yearManufacture: map.getField<int>('year_manufacture'),
      description: map.getFieldOrNull<String>('description'),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAppraisalPayload.fromJson(String source) =>
      CreateAppraisalPayload.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    vehicleBrand,
    vehicleModel,
    yearManufacture,
    description,
  ];
}
