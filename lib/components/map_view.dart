import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../data/models.dart';
import '../utils/helpers.dart';

class InteractiveMapView extends StatelessWidget {
  final List<Property> properties;
  final LatLng initialCenter;
  final double initialZoom;
  final String? selectedPropertyId;
  final ValueChanged<String?> onPropertySelected;
  final bool compact;
  final MapController? mapController;

  const InteractiveMapView({
    super.key,
    required this.properties,
    required this.initialCenter,
    this.initialZoom = 10.0,
    this.selectedPropertyId,
    required this.onPropertySelected,
    this.compact = false,
    this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
        onTap: (_, __) => onPropertySelected(null),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.estately',
          keepBuffer: 5,
          maxNativeZoom: 18,
          maxZoom: 20,
        ),
        MarkerLayer(
          markers: properties.map((prop) {
            final isSelected = prop.id == selectedPropertyId;
            return Marker(
              point: LatLng(prop.latitude, prop.longitude),
              width: isSelected && !compact ? 90 : (compact ? 60 : 70),
              height: compact ? 60 : 44,
              child: GestureDetector(
                onTap: () => onPropertySelected(prop.id),
                child: compact
                    ? _buildCompactMarker(prop)
                    : _buildStandardMarker(prop, isSelected),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStandardMarker(Property prop, bool isSelected) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceContainerLowest : AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected)
                Container(
                  width: 8, height: 8, margin: const EdgeInsets.only(right: 4),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                ),
              Text(
                formatPrice(prop.price, prop.listing),
                style: AppTextStyles.labelSm.withColor(isSelected ? AppColors.primary : AppColors.onPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactMarker(Property prop) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
          child: Text(formatPrice(prop.price, prop.listing), style: AppTextStyles.labelSm.withColor(AppColors.onPrimary)),
        ),
        // A simple triangle pointer
        Container(
          width: 0,
          height: 0,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.primary, width: 8),
              left: BorderSide(color: Colors.transparent, width: 6),
              right: BorderSide(color: Colors.transparent, width: 6),
            ),
          ),
        )
      ],
    );
  }
}
