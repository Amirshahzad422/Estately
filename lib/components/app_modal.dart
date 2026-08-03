import 'package:flutter/material.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import 'app_button.dart';

class AppModal {
  static Future<T?> showConfirm<T>(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(title, style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
          content: Text(message, style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(cancelText, style: AppTextStyles.labelMd.withColor(AppColors.onSurfaceVariant)),
            ),
            AppButton(
              label: confirmText,
              fullWidth: false,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              variant: ButtonVariant.primary,
              // If destructive, we might want to override color, but sticking to primary for now or you can define custom color
              onPressed: onConfirm,
            ),
          ],
        );
      },
    );
  }

  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              child,
            ],
          ),
        );
      },
    );
  }
}
