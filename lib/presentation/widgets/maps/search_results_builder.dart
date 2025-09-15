import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import 'search_result_tile.dart';

class SearchResultsBuilder extends StatelessWidget {
  final bool isDark;
  final VoidCallback onRecentSearches;
  final VoidCallback onSavedPlaces;

  const SearchResultsBuilder({
    super.key,
    required this.isDark,
    required this.onRecentSearches,
    required this.onSavedPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SearchResultTile(),
            ],
          ),
        ),
      ),
    );
  }
}
