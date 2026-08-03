import 'package:flutter/material.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        foregroundColor: AppColors.primary,
        title: Text('About Estately', style: AppTextStyles.headlineMd.withColor(AppColors.primary).copyWith(fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&q=80',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text('Redefining Real Estate.', style: AppTextStyles.headlineLgMobile.withColor(AppColors.primary)),
            const SizedBox(height: 12),
            Text(
              'We are a collective of visionaries, dedicated to matching you with extraordinary spaces. With over a decade of experience, Estately has become the trusted platform for property listings across the globe.',
              style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            // Stats
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _aboutStat('10k+', 'Properties'),
                  _aboutStat('500+', 'Agents'),
                  _aboutStat('\$5B+', 'Volume'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Our Mission', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
            const SizedBox(height: 8),
            Text(
              'To curate exceptional living experiences by providing transparent, expert-led guidance through every step of the real estate journey.',
              style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            Text('Our Vision', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
            const SizedBox(height: 8),
            Text(
              'To be the undisputed leader in luxury real estate, recognized globally for our commitment to design integrity and ethical standards.',
              style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _aboutStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headlineLgMobile.withColor(AppColors.onPrimary)),
        Text(label, style: AppTextStyles.labelSm.withColor(AppColors.onPrimary.withAlpha(180))),
      ],
    );
  }
}
