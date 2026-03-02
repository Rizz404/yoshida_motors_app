// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:car_rongsok_app/feature/appraisal/models/appraisal_request.dart';

class UpdateAppraisalPayload extends Equatable {
  final String? vehicleBrand;
  final String? vehicleModel;
  final int? yearManufacture;
  final String? description;
  final String? licensePlate;
  final int? mileage;
  final List<String>? newPhotos;
  final List<String>? newPhotoLabels;
  final List<int>? deletePhotos;

  const UpdateAppraisalPayload({
    this.vehicleBrand,
    this.vehicleModel,
    this.yearManufacture,
    this.description,
    this.licensePlate,
    this.mileage,
    this.newPhotos,
    this.newPhotoLabels,
    this.deletePhotos,
  });

  bool get isEmpty =>
      vehicleBrand == null &&
      vehicleModel == null &&
      yearManufacture == null &&
      description == null &&
      licensePlate == null &&
      mileage == null &&
      (newPhotos == null || newPhotos!.isEmpty) &&
      (newPhotoLabels == null || newPhotoLabels!.isEmpty) &&
      (deletePhotos == null || deletePhotos!.isEmpty);

  factory UpdateAppraisalPayload.fromChanges({
    required AppraisalRequest original,
    String? vehicleBrand,
    String? vehicleModel,
    int? yearManufacture,
    String? description,
    String? licensePlate,
    int? mileage,
    List<String>? newPhotos,
    List<String>? newPhotoLabels,
    List<int>? deletePhotos,
  }) {
    return UpdateAppraisalPayload(
      vehicleBrand:
          vehicleBrand != null && vehicleBrand != original.vehicleBrand
          ? vehicleBrand
          : null,
      vehicleModel:
          vehicleModel != null && vehicleModel != original.vehicleModel
          ? vehicleModel
          : null,
      yearManufacture:
          yearManufacture != null && yearManufacture != original.yearManufacture
          ? yearManufacture
          : null,
      description: description != null && description != original.description
          ? description
          : null,
      licensePlate:
          licensePlate != null && licensePlate != original.licensePlate
          ? licensePlate
          : null,
      mileage: mileage != null && mileage != original.mileage ? mileage : null,
      newPhotos: newPhotos,
      newPhotoLabels: newPhotoLabels,
      deletePhotos: deletePhotos,
    );
  }

  UpdateAppraisalPayload copyWith({
    String? vehicleBrand,
    String? vehicleModel,
    int? yearManufacture,
    String? description,
    String? licensePlate,
    int? mileage,
    List<String>? newPhotos,
    List<String>? newPhotoLabels,
    List<int>? deletePhotos,
  }) {
    return UpdateAppraisalPayload(
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      yearManufacture: yearManufacture ?? this.yearManufacture,
      description: description ?? this.description,
      licensePlate: licensePlate ?? this.licensePlate,
      mileage: mileage ?? this.mileage,
      newPhotos: newPhotos ?? this.newPhotos,
      newPhotoLabels: newPhotoLabels ?? this.newPhotoLabels,
      deletePhotos: deletePhotos ?? this.deletePhotos,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (vehicleBrand != null) 'vehicle_brand': vehicleBrand,
      if (vehicleModel != null) 'vehicle_model': vehicleModel,
      if (yearManufacture != null) 'year_manufacture': yearManufacture,
      if (description != null) 'description': description,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (mileage != null) 'mileage': mileage,
    };
  }

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap({'_method': 'PATCH', ...toMap()});

    if (newPhotos != null && newPhotos!.isNotEmpty) {
      for (final photoPath in newPhotos!) {
        formData.files.add(
          MapEntry('new_photos[]', await MultipartFile.fromFile(photoPath)),
        );
      }
    }

    if (newPhotoLabels != null && newPhotoLabels!.isNotEmpty) {
      for (final label in newPhotoLabels!) {
        formData.fields.add(MapEntry('new_photo_labels[]', label));
      }
    }

    if (deletePhotos != null && deletePhotos!.isNotEmpty) {
      for (final photoId in deletePhotos!) {
        formData.fields.add(MapEntry('delete_photos[]', photoId.toString()));
      }
    }

    return formData;
  }

  factory UpdateAppraisalPayload.fromMap(Map<String, dynamic> map) {
    return UpdateAppraisalPayload(
      vehicleBrand: map.getFieldOrNull<String>('vehicle_brand'),
      vehicleModel: map.getFieldOrNull<String>('vehicle_model'),
      yearManufacture: map.getFieldOrNull<int>('year_manufacture'),
      description: map.getFieldOrNull<String>('description'),
      licensePlate: map.getFieldOrNull<String>('license_plate'),
      mileage: map.getFieldOrNull<int>('mileage'),
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
    licensePlate,
    mileage,
    newPhotos,
    newPhotoLabels,
    deletePhotos,
  ];
}
