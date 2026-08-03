import 'package:flutter/material.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../components/app_button.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large 404 Graphic
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '404',
                    style: TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryContainer.withAlpha(80),
                      height: 1,
                    ),
                  ),
                  const Icon(
                    Icons.location_off_outlined,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Page Not Found',
                style: AppTextStyles.headlineLgMobile.withColor(AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'The property or page you are looking for does not exist, has been removed, or is temporarily unavailable.',
                style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              AppButton(
                label: 'Return Home',
                icon: Icons.home_outlined,
                onPressed: () {
                  // Pop until the first route (MainLayout)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                fullWidth: false,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Go Back',
                variant: ButtonVariant.text,
                onPressed: () => Navigator.of(context).pop(),
                fullWidth: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
