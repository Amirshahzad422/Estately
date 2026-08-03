import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../components/app_bar.dart';
import '../providers/app_provider.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../utils/helpers.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'property_details_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final savedCount = provider.savedPropertyIds.length;
    final viewedProperties =
        provider.recentlyViewedProperties;
    final enquiries = provider.enquiries;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const EstatelyAppBar(title: 'My Profile'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                20,
                28,
                20,
                28,
              ),
              color: AppColors.surfaceContainerLowest,
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(
                          provider.userAvatar,
                        ),
                        backgroundColor:
                            AppColors.surfaceContainerHigh,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _showComingSoon(
                            context,
                            'Edit Avatar',
                          ),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: AppColors.onPrimary,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.userName,
                    style: AppTextStyles.headlineMd
                        .withColor(AppColors.onSurface),
                  ),
                  Text(
                    provider.userEmail,
                    style: AppTextStyles.bodyMd.withColor(
                      AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer
                          .withAlpha(50),
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Text(
                      provider.userMemberSince,
                      style: AppTextStyles.labelSm
                          .withColor(AppColors.secondary),
                    ),
                  ),
                ],
              ),
            ),
            // Stats
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.surfaceContainerHigh,
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => provider.setNavIndex(3),
                    child: _stat('$savedCount', 'Saved'),
                  ),
                  _vertDivider(),
                  GestureDetector(
                    onTap: () => _showRecentlyViewedSheet(
                      context,
                      viewedProperties,
                    ),
                    child: _stat(
                      '${viewedProperties.length}',
                      'Viewed',
                    ),
                  ),
                  _vertDivider(),
                  GestureDetector(
                    onTap: () => _showEnquiriesSheet(
                      context,
                      enquiries,
                    ),
                    child: _stat(
                      '${enquiries.length}',
                      'Enquiries',
                    ),
                  ),
                ],
              ),
            ),
            // Menu items
            _section('Account'),
            _menuTile(
              Icons.person_outline,
              'Edit Profile',
              () =>
                  _showComingSoon(context, 'Edit Profile'),
            ),
            _menuTile(
              Icons.notifications_outlined,
              'Notifications',
              () =>
                  _showComingSoon(context, 'Notifications'),
            ),
            _menuTile(
              Icons.language_outlined,
              'Language',
              () => _showComingSoon(
                context,
                'Language Settings',
              ),
              trailing: 'English',
            ),
            _section('Activity & Requests'),
            _menuTile(
              Icons.favorite_border,
              'Saved Properties',
              () => provider.setNavIndex(3),
              badge: '$savedCount',
            ),
            _menuTile(
              Icons.history,
              'Recently Viewed',
              () => _showRecentlyViewedSheet(
                context,
                viewedProperties,
              ),
              badge: '${viewedProperties.length}',
            ),
            _menuTile(
              Icons.mail_outline,
              'My Enquiries',
              () => _showEnquiriesSheet(context, enquiries),
              badge: '${enquiries.length}',
            ),
            _section('Support'),
            _menuTile(
              Icons.help_outline,
              'Help Center',
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ContactScreen(),
                  ),
                );
              },
            ),
            _menuTile(
              Icons.privacy_tip_outlined,
              'Privacy Policy',
              () => _showComingSoon(
                context,
                'Privacy Policy',
              ),
            ),
            _menuTile(
              Icons.info_outline,
              'About Estately',
              () => _goAbout(context),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _showSignOutDialog(context),
                  icon: const Icon(
                    Icons.logout,
                    color: AppColors.error,
                    size: 18,
                  ),
                  label: Text(
                    'Sign Out',
                    style: AppTextStyles.labelMd.withColor(
                      AppColors.error,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.error,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Estately v1.0.0',
              style: AppTextStyles.labelSm.withColor(
                AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineMd.withColor(
            AppColors.primary,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.labelSm.withColor(
            AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _vertDivider() => Container(
    width: 1,
    height: 40,
    color: AppColors.outlineVariant.withAlpha(80),
  );

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSm
            .withColor(AppColors.onSurfaceVariant)
            .copyWith(letterSpacing: 1.5),
      ),
    );
  }

  Widget _menuTile(
    IconData icon,
    String label,
    VoidCallback onTap, {
    String? trailing,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.surfaceContainerHigh,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          label,
          style: AppTextStyles.bodyMd
              .withColor(AppColors.onSurface)
              .copyWith(fontSize: 15),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null)
              Text(
                trailing,
                style: AppTextStyles.labelSm.withColor(
                  AppColors.onSurfaceVariant,
                ),
              ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: AppTextStyles.labelSm.withColor(
                    AppColors.onPrimary,
                  ),
                ),
              ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              color: AppColors.outline,
              size: 20,
            ),
          ],
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _goAbout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AboutScreen(),
      ),
    );
  }

  void _showComingSoon(
    BuildContext context,
    String feature,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          feature,
          style: AppTextStyles.headlineMd.withColor(
            AppColors.primary,
          ),
        ),
        content: Text(
          'This feature is currently under development and will be available in the next update.',
          style: AppTextStyles.bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Out',
          style: AppTextStyles.headlineMd.withColor(
            AppColors.primary,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out of your account?',
          style: AppTextStyles.bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signed out successfully.'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: Text(
              'Sign Out',
              style: AppTextStyles.labelMd.withColor(
                AppColors.onPrimary,
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _showRecentlyViewedSheet(
    BuildContext context,
    List<Property> properties,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Recently Viewed Properties',
              style: AppTextStyles.headlineMd.withColor(
                AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: properties.isEmpty
                  ? Center(
                      child: Text(
                        'No recently viewed properties yet',
                        style: AppTextStyles.bodyMd
                            .withColor(
                              AppColors.onSurfaceVariant,
                            ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: properties.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final p = properties[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    PropertyDetailsScreen(
                                      propertyId: p.id,
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(
                              12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors
                                  .surfaceContainerLowest,
                              borderRadius:
                                  BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors
                                    .surfaceContainerHigh,
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(
                                        10,
                                      ),
                                  child: Image.network(
                                    p.images.isNotEmpty
                                        ? p.images.first
                                        : '',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        p.title,
                                        style: AppTextStyles
                                            .labelMd
                                            .withColor(
                                              AppColors
                                                  .onSurface,
                                            ),
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                      ),
                                      Text(
                                        p.city,
                                        style: AppTextStyles
                                            .labelSm
                                            .withColor(
                                              AppColors
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        formatPriceFull(
                                          p.price,
                                          p.listing,
                                        ),
                                        style: AppTextStyles
                                            .labelMd
                                            .withColor(
                                              AppColors
                                                  .primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.outline,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEnquiriesSheet(
    BuildContext context,
    List<Enquiry> enquiries,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Enquiries',
                  style: AppTextStyles.headlineMd.withColor(
                    AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${enquiries.length} Active',
                    style: AppTextStyles.labelSm.withColor(
                      AppColors.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: enquiries.isEmpty
                  ? Center(
                      child: Text(
                        'No enquiries submitted yet',
                        style: AppTextStyles.bodyMd
                            .withColor(
                              AppColors.onSurfaceVariant,
                            ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: enquiries.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final enq = enquiries[i];
                        final dateStr =
                            '${enq.date.day}/${enq.date.month}/${enq.date.year}';
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors
                                .surfaceContainerLowest,
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors
                                  .surfaceContainerHigh,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(
                                          8,
                                        ),
                                    child: Image.network(
                                      enq.propertyImage,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          enq.propertyTitle,
                                          style: AppTextStyles
                                              .labelMd
                                              .withColor(
                                                AppColors
                                                    .onSurface,
                                              ),
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow
                                                  .ellipsis,
                                        ),
                                        Text(
                                          dateStr,
                                          style: AppTextStyles
                                              .labelSm
                                              .withColor(
                                                AppColors
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                    decoration: BoxDecoration(
                                      color:
                                          enq.status.contains(
                                                'Confirmed',
                                              ) ||
                                              enq.status
                                                  .contains(
                                                    'Responded',
                                                  )
                                          ? AppColors
                                                .primaryContainer
                                          : AppColors
                                                .secondaryContainer,
                                      borderRadius:
                                          BorderRadius.circular(
                                            8,
                                          ),
                                    ),
                                    child: Text(
                                      enq.status,
                                      style: AppTextStyles
                                          .labelSm
                                          .withColor(
                                            enq.status.contains(
                                                      'Confirmed',
                                                    ) ||
                                                    enq.status.contains(
                                                      'Responded',
                                                    )
                                                ? AppColors
                                                      .onPrimaryContainer
                                                : AppColors
                                                      .onSecondaryContainer,
                                          )
                                          .copyWith(
                                            fontSize: 10,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.all(
                                      10,
                                    ),
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .surfaceContainerLow,
                                  borderRadius:
                                      BorderRadius.circular(
                                        8,
                                      ),
                                ),
                                child: Text(
                                  '"${enq.message}"',
                                  style: AppTextStyles
                                      .labelSm
                                      .withColor(
                                        AppColors
                                            .onSurfaceVariant,
                                      )
                                      .copyWith(
                                        fontStyle: FontStyle
                                            .italic,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
