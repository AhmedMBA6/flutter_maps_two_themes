import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import 'navigation_item.dart';

class AppDrawerHeader extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavigationChanged;

  const AppDrawerHeader({
    super.key,
    required this.selectedIndex,
    required this.onNavigationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.darkGradientStart,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderDark,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // App title
          _buildAppTitle(),
          
          const SizedBox(height: 20),
          
          // Navigation items
          _buildNavigationRow(),
        ],
      ),
    );
  }

  Widget _buildAppTitle() {
    return const Row(
      children: [
        Icon(
          Icons.location_on,
          color: AppColors.primary,
          size: 32,
        ),
        SizedBox(width: 12),
        Text(
          'Location App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NavigationItem(
          icon: Icons.map,
          label: 'Map',
          index: 0,
          isActive: selectedIndex == 0,
          onTap: () => onNavigationChanged(0),
        ),
        NavigationItem(
          icon: Icons.history,
          label: 'History',
          index: 1,
          isActive: selectedIndex == 1,
          onTap: () => onNavigationChanged(1),
        ),
        NavigationItem(
          icon: Icons.favorite,
          label: 'Favorites',
          index: 2,
          isActive: selectedIndex == 2,
          onTap: () => onNavigationChanged(2),
        ),
        NavigationItem(
          icon: Icons.send,
          label: 'Directions',
          index: 3,
          isActive: selectedIndex == 3,
          onTap: () => onNavigationChanged(3),
        ),
        NavigationItem(
          icon: Icons.person,
          label: 'Profile',
          index: 4,
          isActive: selectedIndex == 4,
          onTap: () => onNavigationChanged(4),
        ),
      ],
    );
  }
}
