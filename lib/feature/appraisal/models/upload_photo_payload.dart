// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:car_rongsok_app/core/extensions/model_parsing_extension.dart';
import 'package:equatable/equatable.dart';

class UploadPhotoPayload extends Equatable {
  final String categoryName;
  final String imagePath;

  const UploadPhotoPayload({
    required this.categoryName,
    required this.imagePath,
  });

  UploadPhotoPayload copyWith({String? categoryName, String? imagePath}) {
    return UploadPhotoPayload(
      categoryName: categoryName ?? this.categoryName,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'category_name': categoryName, 'image': imagePath};
  }

  factory UploadPhotoPayload.fromMap(Map<String, dynamic> map) {
    return UploadPhotoPayload(
      categoryName: map.getField<String>('category_name'),
      imagePath: map.getField<String>('image'),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [categoryName, imagePath];
}
