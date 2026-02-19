// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:equatable/equatable.dart';

class AppraisalPhoto extends Equatable {
  final int id;
  final int appraisalRequestId;
  final String categoryName;
  final String imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppraisalPhoto({
    required this.id,
    required this.appraisalRequestId,
    required this.categoryName,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  AppraisalPhoto copyWith({
    int? id,
    int? appraisalRequestId,
    String? categoryName,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppraisalPhoto(
      id: id ?? this.id,
      appraisalRequestId: appraisalRequestId ?? this.appraisalRequestId,
      categoryName: categoryName ?? this.categoryName,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'appraisal_request_id': appraisalRequestId,
      'category_name': categoryName,
      'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory AppraisalPhoto.fromMap(Map<String, dynamic> map) {
    return AppraisalPhoto(
      id: map.getField<int>('id'),
      appraisalRequestId: map.getField<int>('appraisal_request_id'),
      categoryName: map.getField<String>('category_name'),
      imagePath: map.getField<String>('image_path'),
      createdAt: map.getField<DateTime>('created_at'),
      updatedAt: map.getField<DateTime>('updated_at'),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppraisalPhoto.fromJson(String source) =>
      AppraisalPhoto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    id,
    appraisalRequestId,
    categoryName,
    imagePath,
    createdAt,
    updatedAt,
  ];
}
