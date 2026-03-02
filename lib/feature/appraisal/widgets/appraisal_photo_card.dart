import 'dart:io';

import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/shared/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppraisalPhotoCard extends ConsumerStatefulWidget {
  final int index;
  final String imagePath;
  final String label;
  final bool isLoading;

  const AppraisalPhotoCard({
    super.key,
    required this.index,
    required this.imagePath,
    required this.label,
    required this.isLoading,
  });

  @override
  ConsumerState<AppraisalPhotoCard> createState() => _AppraisalPhotoCardState();
}

class _AppraisalPhotoCardState extends ConsumerState<AppraisalPhotoCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.label);
  }

  @override
  void didUpdateWidget(covariant AppraisalPhotoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.label != widget.label && _controller.text != widget.label) {
      _controller.text = widget.label;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with preview button
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AppImage(
                  imageFile: File(widget.imagePath),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  enablePreview: true,
                ),
              ),
              IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.zoom_in,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Category Name Field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _controller,
                  enabled: !widget.isLoading,
                  decoration: InputDecoration(
                    labelText: context.l10n.cameraCaptureDialogCategoryLabel,
                    hintText: context.l10n.appraisalPhotoCategoryHint,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    ref
                        .read(appraisalFormProvider.notifier)
                        .updatePhotoLabel(widget.index, value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Remove Button
          IconButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    ref
                        .read(appraisalFormProvider.notifier)
                        .removePhoto(widget.index);
                  },
            icon: Icon(Icons.delete_outline, color: context.semantic.error),
            tooltip: context.l10n.appraisalRemovePhotoTooltip,
          ),
        ],
      ),
    );
  }
}
