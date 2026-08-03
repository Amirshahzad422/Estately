import 'package:flutter/material.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../providers/app_provider.dart';

class FiltersPanel extends StatefulWidget {
  final FilterState initialFilters;
  final ValueChanged<FilterState> onApply;

  const FiltersPanel({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  State<FiltersPanel> createState() => _FiltersPanelState();
}

class _FiltersPanelState extends State<FiltersPanel> {
  late FilterState _filters;
  final TextEditingController _locationController =
      TextEditingController();
  final TextEditingController _minPriceController =
      TextEditingController();
  final TextEditingController _maxPriceController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    _locationController.text = _filters.location ?? '';
    _minPriceController.text =
        _filters.minPrice?.toInt().toString() ?? '';
    _maxPriceController.text =
        _filters.maxPrice?.toInt().toString() ?? '';
  }

  @override
  void dispose() {
    _locationController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: AppTextStyles.headlineMd.withColor(
                    AppColors.primary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters = const FilterState();
                      _locationController.clear();
                      _minPriceController.clear();
                      _maxPriceController.clear();
                    });
                  },
                  child: Text(
                    'Reset',
                    style: AppTextStyles.labelMd.withColor(
                      AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                24,
                0,
                24,
                24,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Property Type'),
                  const SizedBox(height: 8),
                  _typeChips([
                    'House',
                    'Apartment',
                    'Villa',
                    'Penthouse',
                    'Plot',
                  ]),
                  const SizedBox(height: 16),
                  _sectionTitle('Listing Type'),
                  const SizedBox(height: 8),
                  _listingChips(),
                  const SizedBox(height: 16),
                  _sectionTitle('Price Range'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _priceField(
                          _minPriceController,
                          'Min Price',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _priceField(
                          _maxPriceController,
                          'Max Price',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Bedrooms'),
                  const SizedBox(height: 8),
                  _bedroomChips(),
                  const SizedBox(height: 16),
                  _sectionTitle('Location'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    onChanged: (v) =>
                        _filters = _filters.copyWith(
                          location: v.isEmpty ? null : v,
                          clearLocation: v.isEmpty,
                        ),
                    style: AppTextStyles.bodyMd.withColor(
                      AppColors.onSurface,
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          'e.g. Beverly Hills, London',
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: AppColors.outline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Sort By'),
                  const SizedBox(height: 8),
                  _sortChips(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final min = double.tryParse(
                          _minPriceController.text,
                        );
                        final max = double.tryParse(
                          _maxPriceController.text,
                        );
                        final f = _filters.copyWith(
                          minPrice: min,
                          maxPrice: max,
                          clearMinPrice: min == null,
                          clearMaxPrice: max == null,
                        );
                        widget.onApply(f);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: AppTextStyles.labelMd
                            .withColor(AppColors.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.labelMd.withColor(
        AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _typeChips(List<String> types) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((t) {
        final isSelected = _filters.type == t;
        return GestureDetector(
          onTap: () => setState(() {
            _filters = isSelected
                ? _filters.copyWith(clearType: true)
                : _filters.copyWith(type: t);
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.outlineVariant,
              ),
            ),
            child: Text(
              t,
              style: AppTextStyles.labelMd.withColor(
                isSelected
                    ? AppColors.onPrimary
                    : AppColors.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _listingChips() {
    return Row(
      children: ['buy', 'rent', 'commercial'].map((l) {
        final isSelected = _filters.listing == l;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              _filters = isSelected
                  ? _filters.copyWith(clearListing: true)
                  : _filters.copyWith(listing: l);
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: l == 'buy'
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                ),
              ),
              child: Text(
                l == 'buy'
                    ? 'Buy'
                    : l == 'rent'
                    ? 'Rent'
                    : 'Commercial',
                textAlign: TextAlign.center,
                style: AppTextStyles.labelMd
                    .withColor(
                      isSelected
                          ? AppColors.onPrimary
                          : AppColors.onSurface,
                    )
                    .copyWith(fontSize: 12),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _bedroomChips() {
    final options = [1, 2, 3, 4, 5];
    return Wrap(
      spacing: 8,
      children: options.map((b) {
        final isSelected = _filters.bedrooms == b;
        return GestureDetector(
          onTap: () => setState(() {
            _filters = isSelected
                ? _filters.copyWith(clearBedrooms: true)
                : _filters.copyWith(bedrooms: b);
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.outlineVariant,
              ),
            ),
            child: Center(
              child: Text(
                b == 5 ? '$b+' : '$b',
                style: AppTextStyles.labelMd.withColor(
                  isSelected
                      ? AppColors.onPrimary
                      : AppColors.onSurface,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sortChips() {
    final options = {
      'newest': 'Newest',
      'price_low': 'Price: Low → High',
      'price_high': 'Price: High → Low',
      'popular': 'Popular',
    };
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.entries.map((entry) {
        final isSelected = _filters.sortBy == entry.key;
        return GestureDetector(
          onTap: () => setState(() {
            _filters = _filters.copyWith(sortBy: entry.key);
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.outlineVariant,
              ),
            ),
            child: Text(
              entry.value,
              style: AppTextStyles.labelSm.withColor(
                isSelected
                    ? AppColors.onPrimary
                    : AppColors.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _priceField(
    TextEditingController controller,
    String hint,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: AppTextStyles.bodyMd.withColor(
        AppColors.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixText: '\$',
        prefixStyle: AppTextStyles.bodyMd.withColor(
          AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
