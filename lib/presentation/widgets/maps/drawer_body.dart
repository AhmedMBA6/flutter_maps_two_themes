import 'package:flutter/material.dart';
import 'drawer_sections/map_section.dart';
import 'drawer_sections/history_section.dart';
import 'drawer_sections/favorites_section.dart';
import 'drawer_sections/directions_section.dart';
import 'drawer_sections/profile_section.dart';

class DrawerBody extends StatelessWidget {
  final int selectedIndex;

  const DrawerBody({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const MapSection();
      case 1:
        return const HistorySection();
      case 2:
        return const FavoritesSection();
      case 3:
        return const DirectionsSection();
      case 4:
        return const ProfileSection();
      default:
        return const MapSection();
    }
  }
}
