// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class CreateAppraisalPayload extends Equatable {
  final String vehicleBrand;
  final String vehicleModel;
  final int yearManufacture;
  final String? description;
  final String? licensePlate;
  final int? mileage;
  final List<String>? photos;
  final List<String>? photoLabels;

  const CreateAppraisalPayload({
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.yearManufacture,
    this.description,
    this.licensePlate,
    this.mileage,
    this.photos,
    this.photoLabels,
  });

  CreateAppraisalPayload copyWith({
    String? vehicleBrand,
    String? vehicleModel,
    int? yearManufacture,
    String? description,
    String? licensePlate,
    int? mileage,
    List<String>? photos,
    List<String>? photoLabels,
  }) {
    return CreateAppraisalPayload(
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      yearManufacture: yearManufacture ?? this.yearManufacture,
      description: description ?? this.description,
      licensePlate: licensePlate ?? this.licensePlate,
      mileage: mileage ?? this.mileage,
      photos: photos ?? this.photos,
      photoLabels: photoLabels ?? this.photoLabels,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'vehicle_brand': vehicleBrand,
      'vehicle_model': vehicleModel,
      'year_manufacture': yearManufacture,
      if (description != null) 'description': description,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (mileage != null) 'mileage': mileage,
    };
  }

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap(toMap());

    if (photos != null && photos!.isNotEmpty) {
      for (final photoPath in photos!) {
        formData.files.add(
          MapEntry('photos[]', await MultipartFile.fromFile(photoPath)),
        );
      }
    }

    if (photoLabels != null && photoLabels!.isNotEmpty) {
      for (final label in photoLabels!) {
        formData.fields.add(MapEntry('photo_labels[]', label));
      }
    }

    return formData;
  }

  factory CreateAppraisalPayload.fromMap(Map<String, dynamic> map) {
    return CreateAppraisalPayload(
      vehicleBrand: map.getField<String>('vehicle_brand'),
      vehicleModel: map.getField<String>('vehicle_model'),
      yearManufacture: map.getField<int>('year_manufacture'),
      description: map.getFieldOrNull<String>('description'),
      licensePlate: map.getFieldOrNull<String>('license_plate'),
      mileage: map.getFieldOrNull<int>('mileage'),
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
    licensePlate,
    mileage,
    photos,
    photoLabels,
  ];
}
