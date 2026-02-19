// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:equatable/equatable.dart';

class UpdateAppraisalPayload extends Equatable {
  final String? vehicleBrand;
  final String? vehicleModel;
  final int? yearManufacture;
  final String? description;

  const UpdateAppraisalPayload({
    this.vehicleBrand,
    this.vehicleModel,
    this.yearManufacture,
    this.description,
  });

  UpdateAppraisalPayload copyWith({
    String? vehicleBrand,
    String? vehicleModel,
    int? yearManufacture,
    String? description,
  }) {
    return UpdateAppraisalPayload(
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      yearManufacture: yearManufacture ?? this.yearManufacture,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (vehicleBrand != null) 'vehicle_brand': vehicleBrand,
      if (vehicleModel != null) 'vehicle_model': vehicleModel,
      if (yearManufacture != null) 'year_manufacture': yearManufacture,
      if (description != null) 'description': description,
    };
  }

  factory UpdateAppraisalPayload.fromMap(Map<String, dynamic> map) {
    return UpdateAppraisalPayload(
      vehicleBrand: map.getFieldOrNull<String>('vehicle_brand'),
      vehicleModel: map.getFieldOrNull<String>('vehicle_model'),
      yearManufacture: map.getFieldOrNull<int>('year_manufacture'),
      description: map.getFieldOrNull<String>('description'),
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateAppraisalPayload.fromJson(String source) =>
      UpdateAppraisalPayload.fromMap(
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
