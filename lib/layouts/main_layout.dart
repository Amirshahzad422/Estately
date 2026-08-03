import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../components/bottom_nav.dart';
import '../screens/home_screen.dart';
import '../screens/listings_screen.dart';
import '../screens/map_search_screen.dart';
import '../screens/saved_screen.dart';
import '../screens/profile_screen.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  static final List<Widget> _screens = [
    const HomeScreen(),
    const ListingsScreen(),
    const MapSearchScreen(),
    const SavedScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: KeyedSubtree(
          key: ValueKey(provider.currentNavIndex),
          child: _screens[provider.currentNavIndex],
        ),
      ),
      bottomNavigationBar: EstatelyBottomNav(
        currentIndex: provider.currentNavIndex,
        onTap: (index) => provider.setNavIndex(index),
      ),
    );
  }
}
