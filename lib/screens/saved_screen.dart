import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../components/app_bar.dart';
import '../components/property_card.dart';
import '../providers/app_provider.dart';
import '../components/app_button.dart';
import '../components/app_modal.dart';
import 'property_details_screen.dart';
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final saved = provider.savedProperties;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: EstatelyAppBar(
        title: 'Saved',
        subtitle: '${saved.length} Properties',
        showProfile: true,
      ),
      body: saved.isEmpty
          ? _buildEmptyState(context, provider)
          : Column(
              children: [
                // Stats bar
                Container(
                  color: AppColors.surfaceContainerLowest,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      _statChip('Total', '${saved.length}'),
                      const SizedBox(width: 8),
                      _statChip('Buy', '${saved.where((p) => p.listing == 'buy').length}'),
                      const SizedBox(width: 8),
                      _statChip('Rent', '${saved.where((p) => p.listing == 'rent').length}'),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          AppModal.showConfirm(
                            context,
                            title: 'Clear Saved',
                            message: 'Remove all saved properties?',
                            confirmText: 'Clear',
                            onConfirm: () {
                              for (final p in saved) provider.toggleSaved(p.id);
                              Navigator.pop(context);
                            },
                          );
                        },
                        child: Text('Clear All', style: AppTextStyles.labelSm.withColor(AppColors.error)),
                      ),
                    ],
                  ),
                ),
                // List
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: saved.length,
                    itemBuilder: (context, index) {
                      final prop = saved[index];
                      return PropertyCard(
                        property: prop,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PropertyDetailsScreen(propertyId: prop.id)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withAlpha(80),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite_border, size: 60, color: AppColors.primary.withAlpha(100)),
          ),
          const SizedBox(height: 24),
          Text('No Saved Properties', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
          const SizedBox(height: 8),
          Text(
            'Start saving properties you love\nby tapping the heart icon.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 28),
          AppButton(
            label: 'Browse Properties',
            icon: Icons.search,
            onPressed: () => provider.setNavIndex(1),
            fullWidth: false,
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(count, style: AppTextStyles.labelMd.withColor(AppColors.primary)),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
