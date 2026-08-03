import 'package:flutter/material.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../components/app_button.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        foregroundColor: AppColors.primary,
        title: Text('Contact Us', style: AppTextStyles.headlineMd.withColor(AppColors.primary).copyWith(fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get in Touch', style: AppTextStyles.headlineLgMobile.withColor(AppColors.primary)),
            const SizedBox(height: 12),
            Text(
              'Have a question about a property or need help with your account? We\'re here to help.',
              style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            // Contact Cards
            _contactMethodCard(
              icon: Icons.mail_outline,
              title: 'Email',
              subtitle: 'support@estately.com',
              actionText: 'Send Email',
            ),
            const SizedBox(height: 16),
            _contactMethodCard(
              icon: Icons.phone_outlined,
              title: 'Phone',
              subtitle: '+1 (800) 555-0198',
              actionText: 'Call Now',
            ),
            const SizedBox(height: 32),
            Text('Send a Message', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
            const SizedBox(height: 16),
            // Form
            const TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'How can we help you?',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Submit Message',
              onPressed: () {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your message has been sent successfully!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
                Future.delayed(const Duration(seconds: 2), () {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                });
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _contactMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A2B4C).withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withAlpha(80),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelMd.withColor(AppColors.primary)),
                Text(subtitle, style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.outline),
        ],
      ),
    );
  }
}
