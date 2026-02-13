import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

class AppDetailActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AppDetailActionButtons({super.key, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final hasDelete = onDelete != null;
    final hasEdit = onEdit != null;

    if (!hasDelete && !hasEdit) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          children: [
            if (hasDelete) ...[
              Expanded(
                child: AppButton(
                  text: context.l10n.sharedDelete,
                  color: AppButtonColor.error,
                  variant: AppButtonVariant.outlined,
                  onPressed: onDelete,
                ),
              ),
              if (hasEdit) const SizedBox(width: 16),
            ],
            if (hasEdit)
              Expanded(
                child: AppButton(
                  text: context.l10n.sharedEdit,
                  onPressed: onEdit,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
