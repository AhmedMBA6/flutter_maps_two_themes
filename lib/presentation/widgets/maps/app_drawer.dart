import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import 'drawer_header.dart';
import 'drawer_body.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _selectedIndex = 0; // 0 = Map, 1 = History, 2 = Favorites, 3 = Directions, 4 = Profile

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkScaffoldColor,
      child: Column(
        children: [
          // Header with navigation bar
          AppDrawerHeader(
            selectedIndex: _selectedIndex,
            onNavigationChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          
          // Body content based on selected navigation
          Expanded(
            child: DrawerBody(
              selectedIndex: _selectedIndex,
            ),
          ),
        ],
      ),
    );
  }
}
