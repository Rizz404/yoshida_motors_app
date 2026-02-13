import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum ImageSize {
  xSmall(16),
  small(24),
  medium(32),
  large(48),
  xLarge(64),
  xxLarge(96),
  xxxLarge(128),
  fullWidth(250); // Ini default height kalau pakai enum fullWidth

  const ImageSize(this.value);
  final double value;
}

enum ImageShape { circle, rectangle }

class AppImage extends StatelessWidget {
  final ImageSize size;
  final String? imageUrl;
  final String? assetPath;
  final Widget? placeholder;
  final Widget? errorWidget;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;
  final double? borderWidth;
  final ImageShape shape;
  final BoxFit fit;
  final Color? backgroundColor;

  // NEW: Custom overrides biar fleksibel!
  final double? width;
  final double? height;

  const AppImage({
    super.key,
    this.size = ImageSize.medium,
    this.imageUrl,
    this.assetPath,
    this.placeholder,
    this.errorWidget,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth,
    this.shape = ImageShape.rectangle,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.width, // Tambahkan ini
    this.height, // Tambahkan ini
  });

  bool get _isNetworkImage =>
      imageUrl != null && Uri.tryParse(imageUrl!)?.hasScheme == true;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Logic: Kalau width/height di-isi manual, pakai itu.
    // Kalau null, baru fallback ke logic Enum.
    final isFullWidthEnum = size == ImageSize.fullWidth;

    final effectiveWidth =
        width ?? (isFullWidthEnum ? double.infinity : size.value);
    final effectiveHeight = height ?? size.value;

    final borderRadius = shape == ImageShape.circle
        ? BorderRadius.circular(effectiveWidth / 2)
        : BorderRadius.circular(12);

    final effectiveBorderColor = borderColor ?? theme.colorScheme.outline;
    final effectiveBorderWidth = borderWidth ?? 1.0;

    Widget imageWidget;

    if (_isNetworkImage) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: effectiveWidth,
        height: effectiveHeight,
        fit: fit,
        placeholder: (context, url) => Skeletonizer(
          enabled: true,
          child: Container(
            width: effectiveWidth,
            height: effectiveHeight,
            color: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Icon(
              Icons.broken_image,
              size: effectiveWidth * 0.5,
              color: theme.colorScheme.error,
            ),
      );
    } else if (assetPath != null) {
      imageWidget = Image.asset(
        assetPath!,
        width: effectiveWidth,
        height: effectiveHeight,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ??
            Icon(
              Icons.broken_image,
              size: effectiveWidth * 0.5,
              color: theme.colorScheme.error,
            ),
      );
    } else {
      imageWidget =
          placeholder ??
          Container(
            width: effectiveWidth,
            height: effectiveHeight,
            color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
          );
    }

    // Container wrapper
    // Hati-hati: kalau width infinity, jangan ditambah margin border nanti error overflow
    final containerWidth = effectiveWidth == double.infinity
        ? double.infinity
        : effectiveWidth + (showBorder ? effectiveBorderWidth * 2 : 0);

    final containerHeight =
        effectiveHeight + (showBorder ? effectiveBorderWidth * 2 : 0);

    final container = Container(
      width: containerWidth,
      // Kalau height null (misal auto), biarkan null. Kalau ada nilainya, pakai containerHeight.
      height: containerHeight,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: showBorder
            ? Border.all(
                color: effectiveBorderColor,
                width: effectiveBorderWidth,
              )
            : null,
      ),
      child: ClipRRect(borderRadius: borderRadius, child: imageWidget),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: container,
      );
    }

    return container;
  }
}
