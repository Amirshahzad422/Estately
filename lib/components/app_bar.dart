import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../providers/app_provider.dart';

class EstatelyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool showSearch;
  final bool showProfile;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? actions;

  const EstatelyAppBar({
    super.key,
    this.title = 'Estately',
    this.showBack = false,
    this.showSearch = false,
    this.showProfile = true,
    this.subtitle,
    this.onBack,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A2B4C).withAlpha(15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (showBack)
              GestureDetector(
                onTap: onBack ?? () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
                ),
              )
            else
              GestureDetector(
                child: const Icon(Icons.menu, color: AppColors.primary, size: 24),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: subtitle != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(title, style: AppTextStyles.headlineMd.withColor(AppColors.primary).copyWith(fontSize: 18)),
                        Text(subtitle!, style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
                      ],
                    )
                  : Text(
                      title,
                      style: AppTextStyles.headlineMd.withColor(AppColors.primary),
                    ),
            ),
            if (actions != null) actions!,
            if (showProfile)
              GestureDetector(
                onTap: () {
                  context.read<AppProvider>().setNavIndex(4);
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    context.watch<AppProvider>().userAvatar,
                  ),
                  backgroundColor: AppColors.surfaceContainerHigh,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
