import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../components/app_bar.dart';
import '../components/property_card.dart';
import '../components/search_bar.dart';
import '../components/filters.dart';
import '../providers/app_provider.dart';
import '../components/app_button.dart';
import '../components/app_modal.dart';
import 'property_details_screen.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() =>
      _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  bool _isGridView = true;
  bool _isLoading = false;
  int _page = 1;
  static const int _pageSize = 6;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final properties = provider.filteredProperties;
    final paginated = properties
        .take(_page * _pageSize)
        .toList();
    final sortLabel =
        {
          'newest': 'Newest',
          'price_low': 'Price: Low → High',
          'price_high': 'Price: High → Low',
          'popular': 'Popular',
        }[provider.filterState.sortBy] ??
        'Newest';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: EstatelyAppBar(
        title: 'Properties',
        subtitle: '${properties.length} found',
        showProfile: true,
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            color: AppColors.surfaceContainerLowest,
            padding: const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              12,
            ),
            child: Column(
              children: [
                // Search
                SearchBarWidget(
                  initialValue:
                      provider.filterState.keyword,
                  onChanged: (v) {
                    provider.updateFilter(
                      provider.filterState.copyWith(
                        keyword: v,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Quick filter chips + view toggle
                Row(
                  children: [
                    // Sort chip
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _quickChip(
                              sortLabel,
                              Icons.sort,
                              true,
                              () => _showFilters(
                                context,
                                provider,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (provider
                                    .filterState
                                    .listing !=
                                null)
                              _quickChip(
                                provider
                                            .filterState
                                            .listing ==
                                        'buy'
                                    ? 'Buy'
                                    : 'Rent',
                                Icons.close,
                                true,
                                () => provider.updateFilter(
                                  provider.filterState
                                      .copyWith(
                                        clearListing: true,
                                      ),
                                ),
                              ),
                            if (provider
                                    .filterState
                                    .bedrooms !=
                                null)
                              _quickChip(
                                '${provider.filterState.bedrooms}+ Beds',
                                Icons.close,
                                true,
                                () => provider.updateFilter(
                                  provider.filterState
                                      .copyWith(
                                        clearBedrooms: true,
                                      ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            _quickChip(
                              'Filter',
                              Icons.tune,
                              false,
                              () => _showFilters(
                                context,
                                provider,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // View toggle
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(
                            () => _isGridView = true,
                          ),
                          child: Icon(
                            Icons.grid_view_rounded,
                            color: _isGridView
                                ? AppColors.primary
                                : AppColors
                                      .onSurfaceVariant,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => setState(
                            () => _isGridView = false,
                          ),
                          child: Icon(
                            Icons.view_list_rounded,
                            color: !_isGridView
                                ? AppColors.primary
                                : AppColors
                                      .onSurfaceVariant,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _isLoading
                ? _buildSkeletonGrid()
                : paginated.isEmpty
                ? _buildEmptyState(provider)
                : _buildPropertyList(
                    context,
                    paginated,
                    properties.length,
                    provider,
                  ),
          ),
        ],
      ),
      // Map View FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => provider.setNavIndex(2),
        backgroundColor: AppColors.primary,
        icon: const Icon(
          Icons.map_outlined,
          color: AppColors.onPrimary,
        ),
        label: Text(
          'Map View',
          style: AppTextStyles.labelMd.withColor(
            AppColors.onPrimary,
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPropertyList(
    BuildContext context,
    List properties,
    int total,
    AppProvider provider,
  ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollEndNotification &&
            n.metrics.pixels >=
                n.metrics.maxScrollExtent - 100) {
          if (_page * _pageSize < total) {
            setState(() => _page++);
          }
        }
        return false;
      },
      child: _isGridView
          ? GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                100,
              ),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
              itemCount:
                  properties.length +
                  ((_page * _pageSize < total) ? 2 : 0),
              itemBuilder: (context, index) {
                if (index >= properties.length)
                  return const SkeletonPropertyCard();
                final prop = properties[index];
                return PropertyCard(
                  property: prop,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PropertyDetailsScreen(
                        propertyId: prop.id,
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                100,
              ),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final prop = properties[index];
                return PropertyCard(
                  property: prop,
                  isListView: true,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PropertyDetailsScreen(
                        propertyId: prop.id,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(AppProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withAlpha(80),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.outline,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Properties Found',
            style: AppTextStyles.headlineMd.withColor(
              AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: AppTextStyles.bodyMd.withColor(
              AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Reset Filters',
            onPressed: () {
              provider.resetFilters();
            },
            fullWidth: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
      itemCount: 6,
      itemBuilder: (_, __) => const SkeletonPropertyCard(),
    );
  }

  Widget _quickChip(
    String label,
    IconData icon,
    bool isPrimary,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primary
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPrimary
                ? AppColors.primary
                : AppColors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.labelSm.withColor(
                isPrimary
                    ? AppColors.onPrimary
                    : AppColors.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              icon,
              size: 14,
              color: isPrimary
                  ? AppColors.onPrimary
                  : AppColors.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilters(
    BuildContext context,
    AppProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FiltersPanel(
        initialFilters: provider.filterState,
        onApply: (f) {
          provider.updateFilter(f);
          Navigator.pop(context);
        },
      ),
    );
  }
}
