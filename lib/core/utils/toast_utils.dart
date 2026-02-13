import 'package:bot_toast/bot_toast.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

/// Utility class untuk menampilkan toast notifications menggunakan BotToast
///
/// Cara pakai:
/// ```dart
/// AppToast.success('Data berhasil disimpan');
/// AppToast.error('Terjadi kesalahan');
/// AppToast.warning('Peringatan penting');
/// AppToast.info('Informasi tambahan');
/// ```
class AppToast {
  AppToast._();

  /// Duration default untuk toast
  static const Duration _defaultDuration = Duration(seconds: 3);

  /// Menampilkan toast dengan tipe success (hijau)
  /// Tidak akan ditampilkan jika message kosong
  static void success(
    String message, {
    Duration? duration,
    VoidCallback? onTap,
  }) {
    if (message.isEmpty) return;
    BotToast.showCustomText(
      duration: duration ?? _defaultDuration,
      onlyOne: true,
      toastBuilder: (context) =>
          _ToastCard(message: message, type: _ToastType.success, onTap: onTap),
    );
  }

  /// Menampilkan toast dengan tipe error (merah)
  static void error(String message, {Duration? duration, VoidCallback? onTap}) {
    if (message.isEmpty) return;
    BotToast.showCustomText(
      duration: duration ?? _defaultDuration,
      onlyOne: true,
      toastBuilder: (context) =>
          _ToastCard(message: message, type: _ToastType.error, onTap: onTap),
    );
  }

  /// Menampilkan toast dengan tipe warning (orange/kuning)
  static void warning(
    String message, {
    Duration? duration,
    VoidCallback? onTap,
  }) {
    if (message.isEmpty) return;
    BotToast.showCustomText(
      duration: duration ?? _defaultDuration,
      onlyOne: true,
      toastBuilder: (context) =>
          _ToastCard(message: message, type: _ToastType.warning, onTap: onTap),
    );
  }

  /// Menampilkan toast dengan tipe info (biru)
  static void info(String message, {Duration? duration, VoidCallback? onTap}) {
    if (message.isEmpty) return;
    BotToast.showCustomText(
      duration: duration ?? _defaultDuration,
      onlyOne: true,
      toastBuilder: (context) =>
          _ToastCard(message: message, type: _ToastType.info, onTap: onTap),
    );
  }

  /// Menampilkan toast untuk server error (5xx) dengan styling khusus
  /// Berbeda dari error biasa agar user tidak bingung
  static void serverError(
    String message, {
    Duration? duration,
    VoidCallback? onTap,
  }) {
    if (message.isEmpty) return;
    BotToast.showCustomText(
      duration: duration ?? _defaultDuration,
      onlyOne: false, // * Allow multiple server error toasts
      toastBuilder: (context) => _ToastCard(
        message: message,
        type: _ToastType.serverError,
        onTap: onTap,
      ),
    );
  }
}

enum _ToastType { success, error, warning, info, serverError }

class _ToastCard extends StatelessWidget {
  const _ToastCard({required this.message, required this.type, this.onTap});

  final String message;
  final _ToastType type;
  final VoidCallback? onTap;

  Color _getBackgroundColor(BuildContext context) {
    final semantic = context.semantic;
    switch (type) {
      case _ToastType.success:
        return semantic.success;
      case _ToastType.error:
        return semantic.error;
      case _ToastType.warning:
        return semantic.warning;
      case _ToastType.info:
        return semantic.info;
      case _ToastType.serverError:
        // * Gunakan warna amber/orange untuk server error (beda dari error merah)
        return context.colorScheme.tertiaryContainer;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case _ToastType.success:
        return Icons.check_circle;
      case _ToastType.error:
        return Icons.error;
      case _ToastType.warning:
        return Icons.warning;
      case _ToastType.info:
        return Icons.info;
      case _ToastType.serverError:
        // * Icon cloud/server untuk server error
        return Icons.cloud_off;
    }
  }

  Color _getTextColor(BuildContext context) {
    // * Server error perlu warna text yang berbeda karena pakai tertiaryContainer
    if (type == _ToastType.serverError) {
      return context.colorScheme.onTertiaryContainer;
    }
    return context.colors.textOnPrimary;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: context.colors.scrim,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getIcon(), color: _getTextColor(context), size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: _getTextColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
