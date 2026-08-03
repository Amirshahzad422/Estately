import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:latlong2/latlong.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../providers/app_provider.dart';
import '../utils/helpers.dart';
import '../components/property_card.dart';
import '../components/app_button.dart';
import '../components/app_modal.dart';
import '../components/map_view.dart';
import '../components/testimonial_card.dart';
import 'agent_screen.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String propertyId;

  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  final PageController _galleryController = PageController();
  bool _descExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AppProvider>().recordView(widget.propertyId);
      }
    });
  }

  Property? get property {
    try {
      return mockProperties.firstWhere((p) => p.id == widget.propertyId);
    } catch (_) {
      return null;
    }
  }

  Agent? get agent => property != null ? getAgent(property!.agentId, mockAgents) : null;

  @override
  void dispose() {
    _galleryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prop = property;
    if (prop == null) return const Scaffold(body: Center(child: Text('Property not found')));

    final provider = context.watch<AppProvider>();
    final isSaved = provider.isSaved(prop.id);
    final similar = mockProperties.where((p) => p.id != prop.id && p.type == prop.type).take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Gallery SliverAppBar
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.surfaceContainerLowest,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest.withAlpha(220),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest.withAlpha(220),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? AppColors.error : AppColors.primary,
                    size: 20,
                  ),
                ),
                onPressed: () => provider.toggleSaved(prop.id),
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest.withAlpha(220),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.share_outlined, color: AppColors.primary, size: 20),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing options coming soon!'), backgroundColor: AppColors.primary),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _galleryController,
                    itemCount: prop.images.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: prop.images[index],
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: AppColors.surfaceContainerHigh),
                      );
                    },
                  ),
                  // Gradient
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withAlpha(100)],
                        ),
                      ),
                    ),
                  ),
                  // Status chip
                  if (prop.status.isNotEmpty)
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 56,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest.withAlpha(230),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text(prop.status, style: AppTextStyles.labelSm.withColor(AppColors.onSurface)),
                          ],
                        ),
                      ),
                    ),
                  // Page indicator
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _galleryController,
                        count: prop.images.length,
                        effect: const WormEffect(
                          dotColor: Colors.white54,
                          activeDotColor: Colors.white,
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price & Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatPriceFull(prop.price, prop.listing),
                              style: AppTextStyles.displayLg.withColor(AppColors.primary).copyWith(fontSize: 32),
                            ),
                            const SizedBox(height: 4),
                            Text(prop.location, style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Key Specs
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(color: AppColors.outlineVariant.withAlpha(80)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _specItem(Icons.bed_outlined, '${prop.bedrooms}', 'Beds'),
                        _divider(),
                        _specItem(Icons.shower_outlined, formatBaths(prop.bathrooms), 'Baths'),
                        _divider(),
                        _specItem(Icons.straighten, '${prop.area}', 'Sq Ft'),
                        _divider(),
                        _specItem(Icons.home_work_outlined, prop.type, 'Type'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Description
                  Text('About this home', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
                  const SizedBox(height: 8),
                  AnimatedCrossFade(
                    firstChild: Text(
                      prop.description,
                      style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    secondChild: Text(
                      prop.description,
                      style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant),
                    ),
                    crossFadeState: _descExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _descExpanded = !_descExpanded),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _descExpanded ? 'Read Less' : 'Read More',
                        style: AppTextStyles.labelMd.withColor(AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Amenities
                  Text('Amenities', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3.5,
                    children: prop.amenities.map((a) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(_amenityIcon(a), color: AppColors.primary, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(a, style: AppTextStyles.labelSm.withColor(AppColors.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Agent Card
                  if (agent != null) _buildAgentCard(context, agent!),
                  const SizedBox(height: 24),
                  // Map
                  _buildMapSection(prop),
                  const SizedBox(height: 24),
                  // Reviews
                  _buildReviews(prop),
                  const SizedBox(height: 24),
                  // Similar Properties
                  if (similar.isNotEmpty) _buildSimilar(context, similar, provider),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Action Bar
      bottomNavigationBar: _buildBottomBar(context, prop, isSaved, provider),
    );
  }

  Widget _specItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.outline, size: 24),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.headlineMd.withColor(AppColors.onSurface).copyWith(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(label, style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _divider() => Container(width: 1, height: 50, color: AppColors.outlineVariant.withAlpha(80));

  Widget _buildAgentCard(BuildContext context, Agent agent) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AgentScreen(agentId: agent.id))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withAlpha(50)),
          boxShadow: [BoxShadow(color: const Color(0xFF1A2B4C).withAlpha(15), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Listed By', style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(radius: 28, backgroundImage: NetworkImage(agent.photo)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(agent.name, style: AppTextStyles.headlineMd.withColor(AppColors.onSurface).copyWith(fontSize: 18)),
                      Text(agent.company, style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant)),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: AppColors.secondaryFixedDim),
                          const SizedBox(width: 4),
                          Text('${agent.rating} (${agent.reviewCount} reviews)', style: AppTextStyles.labelSm.withColor(AppColors.onSurface)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.outline),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Contact Agent',
                    icon: Icons.mail_outline,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Agent contact options coming soon!'), backgroundColor: AppColors.primary),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'Schedule Tour',
                    icon: Icons.calendar_month_outlined,
                    variant: ButtonVariant.outline,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tour scheduling coming soon!'), backgroundColor: AppColors.primary),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(Property prop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Location', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Map navigation coming soon!'), backgroundColor: AppColors.primary),
                );
              },
              child: Text('Open in Maps', style: AppTextStyles.labelSm.withColor(AppColors.primary).copyWith(decoration: TextDecoration.underline)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 180,
            child: InteractiveMapView(
              properties: [prop],
              initialCenter: LatLng(prop.latitude, prop.longitude),
              initialZoom: 14,
              selectedPropertyId: prop.id,
              onPropertySelected: (_) {},
              compact: true,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(prop.location, style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildReviews(Property prop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Reviews', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
            const SizedBox(width: 8),
            const Icon(Icons.star_rounded, color: AppColors.secondaryFixedDim, size: 18),
            const SizedBox(width: 4),
            Text('${prop.rating} (${prop.reviewCount})', style: AppTextStyles.labelMd.withColor(AppColors.onSurface)),
          ],
        ),
        const SizedBox(height: 12),
        ...mockReviews.take(2).map((r) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TestimonialCard(
            name: r.author,
            rating: r.rating,
            comment: r.comment,
            avatarUrl: r.avatar,
            width: double.infinity,
          ),
        )),
      ],
    );
  }

  Widget _buildSimilar(BuildContext context, List<Property> similar, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Similar Properties', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: similar.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final p = similar[i];
              return SizedBox(
                width: 200,
                child: PropertyCard(
                  property: p,
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => PropertyDetailsScreen(propertyId: p.id)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, Property prop, bool isSaved, AppProvider provider) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        boxShadow: [BoxShadow(color: const Color(0xFF1A2B4C).withAlpha(20), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price', style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
              Text(formatPriceFull(prop.price, prop.listing), style: AppTextStyles.headlineMd.withColor(AppColors.primary).copyWith(fontSize: 20)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButton(
              label: 'Enquire Now',
              onPressed: () => _showEnquireModal(context, prop),
            ),
          ),
        ],
      ),
    );
  }

  void _showEnquireModal(BuildContext context, Property prop) {
    final messageController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    AppModal.showBottomSheet(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enquire About This Property', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
          const SizedBox(height: 20),
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Your Name', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 12),
          TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline))),
          const SizedBox(height: 12),
          TextField(controller: messageController, decoration: const InputDecoration(labelText: 'Message', prefixIcon: Icon(Icons.message_outlined)), maxLines: 3),
          const SizedBox(height: 20),
          AppButton(
            label: 'Send Enquiry',
            onPressed: () {
              final msg = messageController.text.trim().isEmpty
                  ? 'Interested in viewing this property.'
                  : messageController.text.trim();
              
              context.read<AppProvider>().addEnquiry(
                Enquiry(
                  id: 'enq_${DateTime.now().millisecondsSinceEpoch}',
                  propertyId: prop.id,
                  propertyTitle: prop.title,
                  propertyImage: prop.images.isNotEmpty ? prop.images.first : '',
                  message: msg,
                  date: DateTime.now(),
                  status: 'Submitted',
                ),
              );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enquiry sent successfully! Updated on your Profile.'), backgroundColor: AppColors.primary),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _amenityIcon(String amenity) {
    final a = amenity.toLowerCase();
    if (a.contains('wifi')) return Icons.wifi;
    if (a.contains('pool')) return Icons.pool;
    if (a.contains('parking') || a.contains('garage')) return Icons.local_parking;
    if (a.contains('gym')) return Icons.fitness_center;
    if (a.contains('wine')) return Icons.wine_bar;
    if (a.contains('security')) return Icons.security;
    if (a.contains('theater')) return Icons.movie;
    if (a.contains('kitchen')) return Icons.kitchen;
    if (a.contains('garden')) return Icons.yard;
    if (a.contains('view')) return Icons.view_quilt;
    if (a.contains('concierge')) return Icons.support_agent;
    if (a.contains('rooftop') || a.contains('deck') || a.contains('terrace')) return Icons.deck;
    if (a.contains('ev')) return Icons.electric_car;
    if (a.contains('smart')) return Icons.home_filled;
    if (a.contains('solar')) return Icons.wb_sunny_outlined;
    if (a.contains('study') || a.contains('office')) return Icons.menu_book_outlined;
    if (a.contains('tennis')) return Icons.sports_tennis;
    if (a.contains('fireplace')) return Icons.fireplace;
    if (a.contains('beach')) return Icons.beach_access;
    if (a.contains('spa')) return Icons.spa;
    return Icons.star_outline;
  }
}
