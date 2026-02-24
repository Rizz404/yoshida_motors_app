// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:car_rongsok_app/core/enums/model_entity_enums.dart';
import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_photo.dart';
import 'package:equatable/equatable.dart';

class AppraisalRequest extends Equatable {
  final int id;
  final int userId;
  final String vehicleBrand;
  final String vehicleModel;
  final int yearManufacture;
  final String? description;
  final String? licensePlate;
  final int? mileage;
  final AppraisalStatus status;
  final double? finalPrice;
  final String? adminNote;
  final DateTime? priceValidUntil;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<AppraisalPhoto>? photos;

  const AppraisalRequest({
    required this.id,
    required this.userId,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.yearManufacture,
    this.description,
    this.licensePlate,
    this.mileage,
    required this.status,
    this.finalPrice,
    this.adminNote,
    this.priceValidUntil,
    required this.createdAt,
    required this.updatedAt,
    this.photos,
  });

  AppraisalRequest copyWith({
    int? id,
    int? userId,
    String? vehicleBrand,
    String? vehicleModel,
    int? yearManufacture,
    String? description,
    String? licensePlate,
    int? mileage,
    AppraisalStatus? status,
    double? finalPrice,
    String? adminNote,
    DateTime? priceValidUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AppraisalPhoto>? photos,
  }) {
    return AppraisalRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      yearManufacture: yearManufacture ?? this.yearManufacture,
      description: description ?? this.description,
      licensePlate: licensePlate ?? this.licensePlate,
      mileage: mileage ?? this.mileage,
      status: status ?? this.status,
      finalPrice: finalPrice ?? this.finalPrice,
      adminNote: adminNote ?? this.adminNote,
      priceValidUntil: priceValidUntil ?? this.priceValidUntil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photos: photos ?? this.photos,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'vehicle_brand': vehicleBrand,
      'vehicle_model': vehicleModel,
      'year_manufacture': yearManufacture,
      if (description != null) 'description': description,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (mileage != null) 'mileage': mileage,
      'status': status.value,
      if (finalPrice != null) 'final_price': finalPrice,
      if (adminNote != null) 'admin_note': adminNote,
      if (priceValidUntil != null)
        'price_valid_until': priceValidUntil?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (photos != null) 'photos': photos!.map((x) => x.toMap()).toList(),
    };
  }

  factory AppraisalRequest.fromMap(Map<String, dynamic> map) {
    return AppraisalRequest(
      id: map.getField<int>('id'),
      userId: map.getField<int>('user_id'),
      vehicleBrand: map.getField<String>('vehicle_brand'),
      vehicleModel: map.getField<String>('vehicle_model'),
      yearManufacture: map.getField<int>('year_manufacture'),
      description: map.getFieldOrNull<String>('description'),
      licensePlate: map.getFieldOrNull<String>('license_plate'),
      mileage: map.getFieldOrNull<int>('mileage'),
      status: AppraisalStatus.values.firstWhere(
        (e) => e.value == map['status'],
        orElse: () => AppraisalStatus.draft,
      ),
      finalPrice: map.getFieldOrNull<double>('final_price'),
      adminNote: map.getFieldOrNull<String>('admin_note'),
      priceValidUntil: map.getFieldOrNull<DateTime>('price_valid_until'),
      createdAt: map.getField<DateTime>('created_at'),
      updatedAt: map.getField<DateTime>('updated_at'),
      photos: map['photos'] != null
          ? List<AppraisalPhoto>.from(
              (map['photos'] as List<dynamic>)
                  .map<AppraisalPhoto>(
                    (x) => AppraisalPhoto.fromMap(x as Map<String, dynamic>),
                  )
                  .toList(),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppraisalRequest.fromJson(String source) =>
      AppraisalRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    id,
    userId,
    vehicleBrand,
    vehicleModel,
    yearManufacture,
    description,
    licensePlate,
    mileage,
    status,
    finalPrice,
    adminNote,
    priceValidUntil,
    createdAt,
    updatedAt,
    photos,
  ];
}
