import 'package:flutter/material.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../components/property_card.dart';
import '../components/app_button.dart';
import '../utils/helpers.dart';
import 'property_details_screen.dart';

class AgentScreen extends StatelessWidget {
  final String agentId;

  const AgentScreen({super.key, required this.agentId});

  @override
  Widget build(BuildContext context) {
    final agent = getAgent(agentId, mockAgents);
    if (agent == null) return const Scaffold(body: Center(child: Text('Agent not found')));

    final agentProperties = mockProperties.where((p) => p.agentId == agentId).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.primary,
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
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primaryContainer, AppColors.primary],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(agent.photo),
                            backgroundColor: AppColors.surfaceContainerHigh,
                          ),
                          if (agent.isVerified)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: AppColors.secondaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.verified, color: AppColors.secondary, size: 16),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(agent.name, style: AppTextStyles.headlineMd.withColor(AppColors.onPrimary)),
                      Text(agent.title, style: AppTextStyles.bodyMd.withColor(AppColors.onPrimary.withAlpha(200))),
                      Text(agent.company, style: AppTextStyles.labelSm.withColor(AppColors.onPrimaryContainer)),
                    ],
                  ),
                ),
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
                  // Stats
                  _buildStats(agent),
                  const SizedBox(height: 24),
                  // Contact Buttons
                  _buildContactButtons(context),
                  const SizedBox(height: 24),
                  // About
                  Text('About ${agent.name}', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
                  const SizedBox(height: 8),
                  Text(agent.about, style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant)),
                  const SizedBox(height: 24),
                  // Reviews snippet
                  _buildRatingBar(agent),
                  const SizedBox(height: 24),
                  // Agent's Listings
                  Text('Active Listings (${agentProperties.length})', style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
                  const SizedBox(height: 12),
                  if (agentProperties.isEmpty)
                    Center(child: Text('No active listings', style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant)))
                  else
                    ...agentProperties.map((prop) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PropertyCard(
                        property: prop,
                        isListView: true,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PropertyDetailsScreen(propertyId: prop.id)),
                        ),
                      ),
                    )),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 14, bottom: MediaQuery.of(context).padding.bottom + 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          boxShadow: [BoxShadow(color: const Color(0xFF1A2B4C).withAlpha(20), blurRadius: 12, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Call',
                icon: Icons.call,
                variant: ButtonVariant.outline,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: 'Message',
                icon: Icons.mail_outline,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(Agent agent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainerHigh),
        boxShadow: [BoxShadow(color: const Color(0xFF1A2B4C).withAlpha(15), blurRadius: 12)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statCol('${agent.propertiesSold}', 'Properties\nSold', Icons.home_outlined),
          _vDivider(),
          _statCol('${agent.yearsExperience}', 'Years\nExperience', Icons.work_outline),
          _vDivider(),
          _statCol('${agent.rating}', 'Client\nRating', Icons.star_outline),
        ],
      ),
    );
  }

  Widget _statCol(String val, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 6),
        Text(val, style: AppTextStyles.headlineMd.withColor(AppColors.primary)),
        Text(label, style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _vDivider() => Container(width: 1, height: 60, color: AppColors.outlineVariant.withAlpha(80));

  Widget _buildContactButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _contactChip(Icons.call_outlined, agent: false, label: 'Call Agent', onTap: () {})),
        const SizedBox(width: 8),
        Expanded(child: _contactChip(Icons.mail_outlined, agent: false, label: 'Send Email', onTap: () {})),
        const SizedBox(width: 8),
        Expanded(child: _contactChip(Icons.calendar_month_outlined, agent: false, label: 'Schedule', onTap: () {})),
      ],
    );
  }

  Widget _contactChip(IconData icon, {required bool agent, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.labelSm.withColor(AppColors.onSurface), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(Agent agent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${agent.rating}', style: AppTextStyles.displayLg.withColor(AppColors.primary).copyWith(fontSize: 40)),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < agent.rating.floor() ? Icons.star_rounded : (i < agent.rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
                  color: AppColors.secondaryFixedDim,
                  size: 18,
                )),
              ),
              Text('${agent.reviewCount} reviews', style: AppTextStyles.labelSm.withColor(AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final frac = (star == 5 ? 0.6 : star == 4 ? 0.25 : star == 3 ? 0.1 : 0.03 + (star - 2) * 0.01);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('$star', style: AppTextStyles.labelSm.withColor(AppColors.onSurface)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: frac,
                            backgroundColor: AppColors.outlineVariant.withAlpha(80),
                            valueColor: const AlwaysStoppedAnimation(AppColors.secondaryFixedDim),
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
