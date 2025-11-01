import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/theme_model.dart';
import '../../../logic_layer/maps/maps_cubit.dart';
import 'circular_action_button.dart';
import 'search_results_builder.dart';

class MapFloatingSearchBar extends StatefulWidget {
  final FloatingSearchBarController controller;
  final VoidCallback onRecentSearches;
  final VoidCallback onSavedPlaces;
  final Function(String) onQueryChanged;
  final Completer<GoogleMapController> mapController;

  const MapFloatingSearchBar({
    super.key,
    required this.controller,
    required this.onRecentSearches,
    required this.onSavedPlaces,
    required this.onQueryChanged,
    required this.mapController,
  });

  @override
  State<MapFloatingSearchBar> createState() => _MapFloatingSearchBarState();
}

class _MapFloatingSearchBarState extends State<MapFloatingSearchBar> {
  bool isPlaceMarkerAdded = false; // Track if the place marker is already added

  @override
  Widget build(BuildContext context) {
    final mapsCubit = context.read<MapsCubit>();
    final themeModel = Provider.of<ThemeModel>(context);
    final isDark = themeModel.isDark;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) async {
        if (state is PlaceDetailsLoaded) {
          final details = state.placeDetails;

          final latLng = LatLng(
            details.location.latitude,
            details.location.longitude,
          );

          // Add marker to the map when the place details are loaded
          final marker = Marker(
            markerId: MarkerId(
                '${details.name}_${latLng.latitude}_${latLng.longitude}'),
            position: latLng,
            infoWindow: InfoWindow(
              title: details.name,
              snippet: details.description,
            ),
            onTap: () async {
              final position = await Geolocator.getCurrentPosition();
              mapsCubit.addCurrentLocationMarker(position);

              // Check if the place marker is clicked and both markers are available
              if (isPlaceMarkerAdded) {
                final destination = LatLng(
                    details.location.latitude, details.location.longitude);

                // Trigger route calculation after both markers are placed
                mapsCubit.emitPlaceDirections(
                  LatLng(position.latitude, position.longitude), // origin
                  destination, // destination
                );

              }
            },
          );

          // Add the searched place marker to the map and move camera to it
          mapsCubit.setSearchedPlaceMarker(marker, moveCamera: true);

          // Update the flag to prevent multiple marker additions
          setState(() {
            isPlaceMarkerAdded = true;
          });

          if (kDebugMode) {
            print('📍 Marker added for ${details.name} at ${latLng.latitude}, ${latLng.longitude}');
          }
        }

        if (state is MapsError) {
          if (kDebugMode) {
            print('❌ Error state: ${state.message}');
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load place details: ${state.message}')),
          );
        }
      },
      child: FloatingSearchBar(
        hint: 'Search places...',
        controller: widget.controller,
        elevation: 6,
        accentColor: isDark ? AppColors.gray400 : AppColors.gray500,
        hintStyle: TextStyle(
          fontSize: 18,
          color: isDark ? AppColors.gray400 : AppColors.gray500,
        ),
        queryStyle: TextStyle(
          fontSize: 16,
          color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
        ),
        border: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.0,
        ),
        margins: const EdgeInsets.fromLTRB(15, 25, 15, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        height: isPortrait ? 56 : 48,
        iconColor: isDark ? AppColors.gray400 : AppColors.gray600,
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 400),
        transitionCurve: Curves.easeInOut,
        progress: false,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 150),
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        onFocusChanged: (isFocused) {
          if (!isFocused) {
            context.read<MapsCubit>().emitClearSuggestions();
          }
        },
        onQueryChanged: widget.onQueryChanged,
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfClosed: false,
            child: CircularActionButton(
              icon: Icons.close,
              onPressed: () => widget.controller.close(),
            ),
          ),
        ],
        builder: (context, transition) {
          return SearchResultsBuilder(
            controller: widget.controller,
            mapController: widget.mapController,
            isDark: isDark,
            onRecentSearches: widget.onRecentSearches,
            onSavedPlaces: widget.onSavedPlaces,
          );
        },
      ),
    );
  }
}
