import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppraisalStepIndicator extends StatelessWidget {
  final int currentStep;

  const AppraisalStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const steps = ['Info', 'Photos', 'Summary'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = index ~/ 2;
          final isDone = stepIndex < currentStep - 1;
          return Expanded(
            child: Container(
              height: 2,
              color: isDone
                  ? context.colorScheme.primary
                  : context.colors.border,
            ),
          );
        }
        final stepIndex = index ~/ 2;
        final isActive = stepIndex == currentStep - 1;
        final isDone = stepIndex < currentStep - 1;
        return _buildDot(
          context,
          label: steps[stepIndex],
          number: stepIndex + 1,
          isActive: isActive,
          isDone: isDone,
        );
      }),
    );
  }

  Widget _buildDot(
    BuildContext context, {
    required String label,
    required int number,
    required bool isActive,
    required bool isDone,
  }) {
    final color = (isActive || isDone)
        ? context.colorScheme.primary
        : context.colors.textTertiary;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: (isActive || isDone)
                ? context.colorScheme.primary
                : context.colors.border,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: context.colors.textOnPrimary,
                  )
                : AppText(
                    '$number',
                    style: AppTextStyle.labelMedium,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? context.colors.textOnPrimary
                        : context.colors.textTertiary,
                  ),
          ),
        ),
        const SizedBox(height: 4),
        AppText(
          label,
          style: AppTextStyle.labelSmall,
          color: color,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ],
    );
  }
}
