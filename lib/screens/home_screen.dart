import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../components/app_bar.dart';
import '../components/property_card.dart';
import '../components/testimonial_card.dart';
import '../providers/app_provider.dart';
import 'property_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _heroIndex = 0;
  int _listingTab = 0; // 0=Buy, 1=Rent, 2=Commercial
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;

  final List<String> _heroImages = [
    'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1200&q=80',
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=1200&q=80',
    'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=1200&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_heroIndex + 1) % _heroImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final featured = mockProperties.where((p) => p.isFeatured).toList();
    final categories = [
      {'icon': Icons.home_work_outlined, 'label': 'Buy'},
      {'icon': Icons.apartment_outlined, 'label': 'Rent'},
      {'icon': Icons.store_outlined, 'label': 'Commercial'},
      {'icon': Icons.landscape_outlined, 'label': 'Plot'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const EstatelyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHero(context, provider),
            const SizedBox(height: 32),
            // Featured Properties
            _buildFeatured(featured, provider),
            const SizedBox(height: 32),
            // Categories
            _buildCategories(categories, provider),
            const SizedBox(height: 32),
            // Why Choose Us
            _buildWhyChooseUs(),
            const SizedBox(height: 32),
            // Testimonials
            _buildTestimonials(),
            const SizedBox(height: 32),
            // CTA
            _buildCta(context, provider),
            const SizedBox(height: 32),
            // Footer
            _buildFooter(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, AppProvider provider) {
    return Stack(
      children: [
        // Hero Image Carousel
        SizedBox(
          height: 540,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _heroIndex = index),
            itemCount: _heroImages.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: _heroImages[index],
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.surfaceContainerHigh),
              );
            },
          ),
        ),
        // Gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.primary.withAlpha(220),
                ],
              ),
            ),
          ),
        ),
        // Content
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Find Your Dream Home',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineLgMobile.withColor(AppColors.onPrimary).copyWith(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover premium properties in the most exclusive neighborhoods.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd.withColor(AppColors.onPrimary.withAlpha(230)),
                ),
                const SizedBox(height: 20),
                // Search Box
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Buy/Rent/Commercial tabs
                      Row(
                        children: ['Buy', 'Rent', 'Commercial'].asMap().entries.map((e) {
                          final selected = e.key == _listingTab;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _listingTab = e.key),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: selected ? AppColors.primary : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  e.value,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.labelMd.withColor(selected ? AppColors.primary : AppColors.onSurfaceVariant),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.outlineVariant.withAlpha(128)),
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: Icon(Icons.search, color: AppColors.outline, size: 20),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search location...',
                                        hintStyle: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              provider.updateFilter(provider.filterState.copyWith(
                                keyword: _searchController.text,
                                listing: _listingTab == 0 ? 'buy' : _listingTab == 1 ? 'rent' : _listingTab == 2 ? 'commercial' : null,
                              ));
                              provider.setNavIndex(1);
                            },
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text('Search', style: AppTextStyles.labelMd.withColor(AppColors.onPrimary)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Hero dots aligned left below search widget
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ..._heroImages.asMap().entries.map((e) {
                      return GestureDetector(
                        onTap: () => _pageController.animateToPage(e.key, duration: const Duration(milliseconds: 300), curve: Curves.easeIn),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: e.key == _heroIndex ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: e.key == _heroIndex ? AppColors.onPrimary : AppColors.onPrimary.withAlpha(128),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatured(List<Property> featured, AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Featured Properties', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
              GestureDetector(
                onTap: () => provider.setNavIndex(1),
                child: Text('See all', style: AppTextStyles.labelMd.withColor(AppColors.primary).copyWith(decoration: TextDecoration.underline)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 330,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featured.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final prop = featured[index];
                return SizedBox(
                  width: 220,
                  child: PropertyCard(
                    property: prop,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PropertyDetailsScreen(propertyId: prop.id),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(List<Map<String, Object>> categories, AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Browse by Category', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: categories.map((cat) {
              return GestureDetector(
                onTap: () {
                  final label = cat['label'] as String;
                  if (label == 'Buy') {
                    provider.updateFilter(provider.filterState.copyWith(listing: 'buy', clearType: true, clearListing: false));
                  } else if (label == 'Rent') {
                    provider.updateFilter(provider.filterState.copyWith(listing: 'rent', clearType: true, clearListing: false));
                  } else if (label == 'Commercial') {
                    provider.updateFilter(provider.filterState.copyWith(listing: 'commercial', clearType: true, clearListing: false));
                  } else if (label == 'Plot') {
                    provider.updateFilter(provider.filterState.copyWith(type: 'Plot', clearListing: true, clearType: false));
                  }
                  provider.setNavIndex(1);
                },
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(30),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(cat['icon'] as IconData, color: AppColors.onPrimaryContainer, size: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(cat['label'] as String, style: AppTextStyles.labelSm.withColor(AppColors.onSurface)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseUs() {
    final reasons = [
      {'icon': Icons.verified_outlined, 'title': 'Verified Listings', 'desc': 'All properties are thoroughly verified'},
      {'icon': Icons.support_agent_outlined, 'title': 'Expert Agents', 'desc': '500+ certified professionals'},
      {'icon': Icons.price_check_outlined, 'title': 'Best Prices', 'desc': 'Competitive market rates guaranteed'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Why Choose Estately', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
          const SizedBox(height: 16),
          ...reasons.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceContainerHigh),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(r['icon'] as IconData, color: AppColors.onPrimaryContainer, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r['title'] as String, style: AppTextStyles.labelMd.withColor(AppColors.onSurface)),
                      Text(r['desc'] as String, style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTestimonials() {
    final testimonials = [
      {'name': 'James M.', 'rating': 5.0, 'comment': 'Found my dream home in just 2 weeks. Amazing service!', 'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80'},
      {'name': 'Amanda C.', 'rating': 4.8, 'comment': 'Professional team and beautiful properties. Highly recommend.', 'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80'},
      {'name': 'Robert H.', 'rating': 5.0, 'comment': 'The best real estate experience I have ever had!', 'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What Our Clients Say', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: testimonials.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, i) {
                final t = testimonials[i];
                return TestimonialCard(
                  name: t['name'] as String,
                  rating: t['rating'] as double,
                  comment: t['comment'] as String,
                  avatarUrl: t['avatar'] as String,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCta(BuildContext context, AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
          image: const DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ready to Find\nYour Perfect Home?', style: AppTextStyles.headlineLgMobile.withColor(AppColors.onPrimary)),
            const SizedBox(height: 12),
            Text('Browse thousands of premium listings today.', style: AppTextStyles.bodyMd.withColor(AppColors.onPrimary.withAlpha(204))),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                GestureDetector(
                  onTap: () => provider.setNavIndex(1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Browse Listings', style: AppTextStyles.labelMd.withColor(AppColors.primary)),
                  ),
                ),
                GestureDetector(
                  onTap: () => provider.setNavIndex(2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.onPrimary.withAlpha(128)),
                    ),
                    child: Text('View Map', style: AppTextStyles.labelMd.withColor(AppColors.onPrimary)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, AppProvider provider) {
    return Container(
      width: double.infinity,
      color: AppColors.surfaceContainerLowest,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withAlpha(80),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.maps_home_work_outlined, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text('Estately', style: AppTextStyles.headlineMd.withColor(AppColors.primary).copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Premium Real Estate Marketplace', style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _footerLink('About Us', () => _goToAbout(context)),
              const SizedBox(width: 24),
              _footerLink('Contact', () => _goToContact(context)),
              const SizedBox(width: 24),
              _footerLink('Listings', () => provider.setNavIndex(1)),
            ],
          ),
          const SizedBox(height: 32),
          Divider(color: AppColors.outlineVariant.withAlpha(80)),
          const SizedBox(height: 20),
          Text('© 2026 Estately. All rights reserved.', style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _footerLink(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: AppTextStyles.labelMd.withColor(AppColors.primary)),
    );
  }

  void _goToAbout(BuildContext context) {
    _goToAboutScreen(context);
  }

  void _goToContact(BuildContext context) {
    _goToContactScreen(context);
  }

  void _goToAboutScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _AboutUsScreen()));
  }

  void _goToContactScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _ContactScreen()));
  }
}

class _AboutUsScreen extends StatelessWidget {
  const _AboutUsScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network('https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&q=80', height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            Text('Redefining Real Estate.', style: AppTextStyles.headlineLgMobile.withColor(AppColors.primary)),
            const SizedBox(height: 12),
            Text('We are a collective of visionaries, dedicated to matching you with extraordinary spaces. With over a decade of experience, Estately has become the trusted platform for property listings across the globe.', style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _s('10k+', 'Properties Sold'),
                  _s('500+', 'Expert Agents'),
                  _s('\$5B+', 'Sales Volume'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _s(String v, String l) => Column(children: [
    Text(v, style: AppTextStyles.headlineMd.withColor(AppColors.onPrimary)),
    Text(l, style: AppTextStyles.labelSm.withColor(AppColors.onPrimary.withAlpha(180)), textAlign: TextAlign.center),
  ]);
}

class _ContactScreen extends StatelessWidget {
  const _ContactScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text('Get In Touch', style: AppTextStyles.headlineLgMobile.withColor(AppColors.primary)),
            const SizedBox(height: 8),
            Text('We\'re here to help you find your perfect property.', style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant)),
            const SizedBox(height: 24),
            const TextField(decoration: InputDecoration(labelText: 'Your Name', prefixIcon: Icon(Icons.person_outline))),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline))),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Subject', prefixIcon: Icon(Icons.subject))),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Message', prefixIcon: Icon(Icons.message_outlined)), maxLines: 4),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message sent! We\'ll be in touch.'), backgroundColor: AppColors.primary));
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text('Send Message', style: AppTextStyles.labelMd.withColor(AppColors.onPrimary)),
              ),
            ),
            const SizedBox(height: 24),
            _infoRow(Icons.mail_outlined, 'Email', 'hello@estately.com'),
            const SizedBox(height: 12),
            _infoRow(Icons.call_outlined, 'Phone', '+1 (800) 555-0199'),
            const SizedBox(height: 12),
            _infoRow(Icons.location_on_outlined, 'Office', '123 Market St, Suite 400\nSan Francisco, CA 94105'),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
            Text(value, style: AppTextStyles.bodyMd.withColor(AppColors.onSurface)),
          ],
        ),
      ],
    );
  }
}
