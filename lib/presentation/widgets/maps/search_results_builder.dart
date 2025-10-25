// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../../../constants/themes/app_colors.dart';
import '../../../data_layer/models/map/place_details.dart';
import 'search_result_tile.dart';

class SearchResultsBuilder extends StatefulWidget {
  final bool isDark;
  final VoidCallback onRecentSearches;
  final VoidCallback onSavedPlaces;
  final Completer<GoogleMapController> mapController;
  final FloatingSearchBarController controller;
  final void Function() onTap;


  const SearchResultsBuilder({
    super.key,
    required this.isDark,
    required this.onRecentSearches,
    required this.onSavedPlaces,
    required this.mapController,
    required this.controller,
     required this.onTap,
  });

  @override
  State<SearchResultsBuilder> createState() => _SearchResultsBuilderState();
}

class _SearchResultsBuilderState extends State<SearchResultsBuilder> {
  late PlaceDetails selectedPlace;
  

  late CameraPosition searchPlaceCameraPosition;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SearchResultTile(
                controller: widget.controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
