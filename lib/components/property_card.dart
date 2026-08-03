import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../data/models.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../utils/helpers.dart';
import '../providers/app_provider.dart';

class PropertyCard extends StatefulWidget {
  final Property property;
  final VoidCallback onTap;
  final bool isListView;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    this.isListView = false,
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isSaved = provider.isSaved(widget.property.id);

    if (widget.isListView) {
      return _buildListCard(isSaved, provider);
    }
    return _buildGridCard(isSaved, provider);
  }

  Widget _buildGridCard(bool isSaved, AppProvider provider) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceContainerHigh),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A2B4C).withAlpha(15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: CachedNetworkImage(
                      imageUrl: widget.property.images.first,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: AppColors.surfaceContainerHigh,
                        highlightColor: AppColors.surfaceContainerLow,
                        child: Container(color: AppColors.surfaceContainerHigh),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.surfaceContainer,
                        child: const Icon(Icons.image_not_supported, color: AppColors.outline),
                      ),
                    ),
                  ),
                  // Gradient
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withAlpha(50)],
                        ),
                      ),
                    ),
                  ),
                  // Status chip
                  if (widget.property.status.isNotEmpty)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest.withAlpha(230),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.property.status,
                          style: AppTextStyles.labelSm.withColor(AppColors.primary),
                        ),
                      ),
                    ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => provider.toggleSaved(widget.property.id),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest.withAlpha(230),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isSaved ? AppColors.error : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Content
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  children: [
                    Text(
                      formatPriceFull(widget.property.price, widget.property.listing),
                      style: AppTextStyles.headlineMd.withColor(AppColors.primary).copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.property.title,
                      style: AppTextStyles.bodyMd.withColor(AppColors.onSurface).copyWith(fontWeight: FontWeight.w500, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppColors.outline),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            widget.property.location,
                            style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(color: AppColors.surfaceContainerHigh, height: 1),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _specSmall(Icons.bed_outlined, '${widget.property.bedrooms}'),
                        _specSmall(Icons.shower_outlined, formatBaths(widget.property.bathrooms)),
                        _specSmall(Icons.straighten, '${widget.property.area}'),
                      ],
                    ),
                  ],
                ),
              ),],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(bool isSaved, AppProvider provider) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceContainerHigh),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A2B4C).withAlpha(15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              // Image
              SizedBox(
                width: 120,
                height: 120,
                child: CachedNetworkImage(
                  imageUrl: widget.property.images.first,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: AppColors.surfaceContainerHigh,
                    highlightColor: AppColors.surfaceContainerLow,
                    child: Container(color: AppColors.surfaceContainerHigh),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatPriceFull(widget.property.price, widget.property.listing),
                        style: AppTextStyles.headlineMd.withColor(AppColors.primary).copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.property.title,
                        style: AppTextStyles.labelMd.withColor(AppColors.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.property.location,
                        style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _specSmall(Icons.bed_outlined, '${widget.property.bedrooms}'),
                          const SizedBox(width: 12),
                          _specSmall(Icons.shower_outlined, formatBaths(widget.property.bathrooms)),
                          const SizedBox(width: 12),
                          _specSmall(Icons.straighten, '${widget.property.area}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Favorite
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => provider.toggleSaved(widget.property.id),
                  child: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? AppColors.error : AppColors.onSurfaceVariant,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _spec(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _specSmall(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 2),
        Text(label, style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant).copyWith(fontSize: 11)),
      ],
    );
  }
}

// Skeleton Card for loading state
class SkeletonPropertyCard extends StatelessWidget {
  const SkeletonPropertyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceContainerHigh,
      highlightColor: AppColors.surfaceContainerLow,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: Container(color: AppColors.surfaceContainerHigh),
            ),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                children: [
                  Container(height: 20, width: 90, color: AppColors.surfaceContainerHigh, margin: const EdgeInsets.only(bottom: 6)),
                  Container(height: 14, width: double.infinity, color: AppColors.surfaceContainerHigh, margin: const EdgeInsets.only(bottom: 6)),
                  Container(height: 12, width: 120, color: AppColors.surfaceContainerHigh, margin: const EdgeInsets.only(bottom: 12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(height: 12, width: 30, color: AppColors.surfaceContainerHigh),
                      Container(height: 12, width: 30, color: AppColors.surfaceContainerHigh),
                      Container(height: 12, width: 40, color: AppColors.surfaceContainerHigh),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
