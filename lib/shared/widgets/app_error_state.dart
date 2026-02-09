import 'package:flutter/material.dart';
import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';

/// Widget untuk menampilkan error state yang reusable
class AppErrorState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const AppErrorState({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.semantic.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: context.semantic.error),
            ),
            const SizedBox(height: 24),
            AppText(
              title,
              style: AppTextStyle.titleLarge,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            AppText(
              description,
              style: AppTextStyle.bodyMedium,
              color: context.colors.textSecondary,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText ?? context.l10n.sharedRetry),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
