import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../providers/app_provider.dart';
import '../utils/helpers.dart';
import '../components/map_view.dart';
import '../components/filters.dart';
import 'property_details_screen.dart';
import 'package:flutter_map/flutter_map.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> with TickerProviderStateMixin {
  String? _selectedPropertyId;
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    try {
      final latTween = Tween<double>(begin: _mapController.camera.center.latitude, end: destLocation.latitude);
      final lngTween = Tween<double>(begin: _mapController.camera.center.longitude, end: destLocation.longitude);
      final zoomTween = Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

      final controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
      final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

      controller.addListener(() {
        _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation),
        );
      });

      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
          controller.dispose();
        }
      });

      controller.forward();
    } catch (e) {
      _mapController.move(destLocation, destZoom);
    }
  }

  void _fitMapToProperties(List<Property> props) {
    if (props.isEmpty) return;
    
    if (props.length == 1) {
      _animatedMapMove(LatLng(props.first.latitude, props.first.longitude), 14.0);
      return;
    }

    double minLat = props.first.latitude;
    double maxLat = props.first.latitude;
    double minLng = props.first.longitude;
    double maxLng = props.first.longitude;
    for (var p in props) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;
    
    double latDiff = maxLat - minLat;
    double lngDiff = maxLng - minLng;
    double maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    
    double zoom = 10.0;
    if (maxDiff < 0.02) zoom = 14.0;
    else if (maxDiff < 0.05) zoom = 13.0;
    else if (maxDiff < 0.1) zoom = 12.0;
    else if (maxDiff < 0.5) zoom = 10.0;
    else if (maxDiff < 1.0) zoom = 8.0;
    else if (maxDiff < 5.0) zoom = 6.0;
    else zoom = 4.0;
    
    _animatedMapMove(LatLng(centerLat, centerLng), zoom);
  }

  void _onSearch(String query) {
    setState(() {
      _selectedPropertyId = null;
    });
    
    final provider = context.read<AppProvider>();
    List<Property> displayed = provider.filteredProperties;
    
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      displayed = displayed.where((p) =>
        p.title.toLowerCase().contains(q) ||
        p.city.toLowerCase().contains(q) ||
        p.location.toLowerCase().contains(q)
      ).toList();
    }
    
    _fitMapToProperties(displayed);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    
    List<Property> displayed = provider.filteredProperties;
    if (_searchController.text.isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      displayed = displayed.where((p) =>
        p.title.toLowerCase().contains(q) ||
        p.city.toLowerCase().contains(q) ||
        p.location.toLowerCase().contains(q)
      ).toList();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen Map
          InteractiveMapView(
            mapController: _mapController,
            properties: displayed,
            initialCenter: const LatLng(34.0736, -118.4004),
            initialZoom: 10,
            selectedPropertyId: _selectedPropertyId,
            onPropertySelected: (id) {
              setState(() => _selectedPropertyId = id);
              if (id != null) {
                final prop = displayed.firstWhere((p) => p.id == id);
                _animatedMapMove(LatLng(prop.latitude, prop.longitude), 13.0);
              }
            },
          ),
          // Top Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => provider.setNavIndex(0),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 8)],
                    ),
                    child: const Icon(Icons.arrow_back, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Icon(Icons.search, color: AppColors.outline, size: 20)),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearch,
                            style: AppTextStyles.bodyMd.withColor(AppColors.onSurface),
                            decoration: InputDecoration(
                              hintText: 'Search areas, cities...',
                              hintStyle: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () { _searchController.clear(); _onSearch(''); },
                            child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Icon(Icons.close, color: AppColors.onSurfaceVariant, size: 18)),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => FiltersPanel(
                        initialFilters: provider.filterState,
                        onApply: (f) {
                          provider.updateFilter(f);
                          Navigator.pop(context);
                          
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              final updatedDisplayed = context.read<AppProvider>().filteredProperties;
                              _fitMapToProperties(updatedDisplayed);
                            }
                          });
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 8)],
                    ),
                    child: const Icon(Icons.tune, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          // Right side FABs
          Positioned(
            right: 16,
            bottom: 200,
            child: Column(
              children: [
                _mapFab(Icons.my_location, () {
                  _animatedMapMove(const LatLng(34.0736, -118.4004), 10.0);
                }),
                const SizedBox(height: 8),
                _mapFab(Icons.layers_outlined, () {
                  _animatedMapMove(const LatLng(34.0736, -118.4004), 8.0);
                }),
              ],
            ),
          ),
          // Bottom cards
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedPropertyId != null) _buildSelectedCard(context, provider),
                if (_selectedPropertyId == null) _buildPropertyCarousel(context, displayed),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapFab(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 8)],
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
    );
  }

  Widget _buildSelectedCard(BuildContext context, AppProvider provider) {
    final prop = mockProperties.firstWhere((p) => p.id == _selectedPropertyId!, orElse: () => mockProperties.first);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PropertyDetailsScreen(propertyId: prop.id))),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 16)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(prop.images.first, width: 90, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatPriceFull(prop.price, prop.listing), style: AppTextStyles.headlineMd.withColor(AppColors.primary).copyWith(fontSize: 20)),
                  Text(prop.title, style: AppTextStyles.labelMd.withColor(AppColors.onSurface)),
                  Text(prop.city, style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _miniSpec(Icons.bed_outlined, '${prop.bedrooms}'),
                      const SizedBox(width: 8),
                      _miniSpec(Icons.shower_outlined, formatBaths(prop.bathrooms)),
                      const SizedBox(width: 8),
                      _miniSpec(Icons.straighten, '${prop.area}'),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(provider.isSaved(prop.id) ? Icons.favorite : Icons.favorite_border,
                color: provider.isSaved(prop.id) ? AppColors.error : AppColors.onSurfaceVariant),
              onPressed: () => provider.toggleSaved(prop.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCarousel(BuildContext context, List<Property> displayed) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: displayed.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final prop = displayed[i];
          return GestureDetector(
            onTap: () {
              setState(() => _selectedPropertyId = prop.id);
              _animatedMapMove(LatLng(prop.latitude, prop.longitude), 13.0);
            },
            child: Container(
              width: 260,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 12)],
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  Image.network(prop.images.first, width: 100, height: 200, fit: BoxFit.cover),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(formatPriceFull(prop.price, prop.listing), style: AppTextStyles.headlineMd.withColor(AppColors.primary).copyWith(fontSize: 16)),
                          Text(prop.title, style: AppTextStyles.labelMd.withColor(AppColors.onSurface), maxLines: 2, overflow: TextOverflow.ellipsis),
                          Text(prop.city, style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
                          const Spacer(),
                          Row(
                            children: [
                              _miniSpec(Icons.bed_outlined, '${prop.bedrooms}'),
                              const SizedBox(width: 6),
                              _miniSpec(Icons.straighten, '${prop.area}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _miniSpec(IconData icon, String val) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 2),
        Text(val, style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant).copyWith(fontSize: 10)),
      ],
    );
  }
}
