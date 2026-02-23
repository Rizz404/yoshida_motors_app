import 'package:car_rongsok_app/feature/appraisal/models/create_appraisal_payload.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Holds the appraisalId for the current appraisal flow:
/// summary → result
final currentAppraisalIdProvider = StateProvider<int?>((ref) => null);

/// Holds the category name when navigating to CameraCaptureScreen
final currentPhotoCategoryProvider = StateProvider<String?>((ref) => null);

/// Holds the temporary form data while taking photos
final appraisalFormProvider =
    StateNotifierProvider<AppraisalFormNotifier, CreateAppraisalPayload?>((
      ref,
    ) {
      return AppraisalFormNotifier();
    });

class AppraisalFormNotifier extends StateNotifier<CreateAppraisalPayload?> {
  AppraisalFormNotifier() : super(null);

  void setVehicleInfo({
    required String brand,
    required String model,
    required int year,
    String? description,
  }) {
    state = CreateAppraisalPayload(
      vehicleBrand: brand,
      vehicleModel: model,
      yearManufacture: year,
      description: description,
      photos: [],
      photoLabels: [],
    );
  }

  void addPhoto(String categoryName, String imagePath) {
    if (state == null) return;

    final currentPhotos = List<String>.from(state!.photos ?? []);
    final currentLabels = List<String>.from(state!.photoLabels ?? []);

    currentPhotos.add(imagePath);
    currentLabels.add(categoryName);

    state = state!.copyWith(photos: currentPhotos, photoLabels: currentLabels);
  }

  void removePhoto(int index) {
    if (state == null) return;

    final currentPhotos = List<String>.from(state!.photos ?? []);
    final currentLabels = List<String>.from(state!.photoLabels ?? []);

    if (index >= 0 && index < currentPhotos.length) {
      currentPhotos.removeAt(index);
      currentLabels.removeAt(index);
      state = state!.copyWith(
        photos: currentPhotos,
        photoLabels: currentLabels,
      );
    }
  }

  void updatePhotoLabel(int index, String newLabel) {
    if (state == null) return;

    final currentLabels = List<String>.from(state!.photoLabels ?? []);
    if (index >= 0 && index < currentLabels.length) {
      currentLabels[index] = newLabel;
      state = state!.copyWith(photoLabels: currentLabels);
    }
  }

  void clearForm() {
    state = null;
  }
}
