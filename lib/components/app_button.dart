import 'package:flutter/material.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';

enum ButtonVariant { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.width,
    this.height = 50,
    this.padding,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide? border;

    switch (variant) {
      case ButtonVariant.primary:
        bg = AppColors.primary;
        fg = AppColors.onPrimary;
        break;
      case ButtonVariant.secondary:
        bg = AppColors.secondaryContainer;
        fg = AppColors.primary;
        break;
      case ButtonVariant.outline:
        bg = Colors.transparent;
        fg = AppColors.primary;
        border = const BorderSide(color: AppColors.primary);
        break;
      case ButtonVariant.text:
        bg = Colors.transparent;
        fg = AppColors.primary;
        break;
    }

    if (onPressed == null) {
      bg = variant == ButtonVariant.outline || variant == ButtonVariant.text 
          ? Colors.transparent 
          : AppColors.surfaceContainerHigh;
      fg = AppColors.onSurfaceVariant.withAlpha(128);
      if (border != null) {
        border = BorderSide(color: AppColors.outlineVariant.withAlpha(128));
      }
    }

    Widget content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          ),
          const SizedBox(width: 10),
        ] else if (icon != null) ...[
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 8),
        ],
        if (fullWidth)
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.labelMd.withColor(fg).copyWith(
                    fontSize: fontSize,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        else
          Text(
            label,
            style: AppTextStyles.labelMd.withColor(fg).copyWith(
                  fontSize: fontSize,
                ),
          ),
      ],
    );

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: border ?? BorderSide.none,
          ),
        ),
        child: content,
      ),
    );
  }
}
