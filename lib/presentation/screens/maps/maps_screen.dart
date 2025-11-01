import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import '../../../logic_layer/maps/maps_cubit.dart';
import '../../widgets/maps/maps_widgets.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> with WidgetsBindingObserver {
  // Controllers
  final Completer<GoogleMapController> _mapController = Completer();
  final FloatingSearchBarController _searchController =
      FloatingSearchBarController();

  // State
  static Position? _currentPosition;
  bool _isCenteringLocation = false;
  late Marker currentLocationMarker;
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final mapsCubit = context.read<MapsCubit>();
    mapsCubit.emitClearSuggestions();
    mapsCubit.initializeLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapsCubit = context.read<MapsCubit>();
    return SafeArea(
      child: Scaffold(
          drawer: const AppDrawer(),
          body: RepaintBoundary(
            child: Stack(
              children: [
                const MapWidget(defaultZoom: 17.0),
                MapFloatingSearchBar(
                  controller: _searchController,
                  onRecentSearches: () {},
                  onSavedPlaces: () {},
                  onQueryChanged: mapsCubit.handleSearchQuery,
                  mapController: _mapController,
                ),
              ],
            ),
          ),
          floatingActionButton: LocationFloatingActionButton(
              onPressed: () async {
                setState(() {
                  _isCenteringLocation = true;
                });
                await mapsCubit.centerOnUserLocation();
                setState(() {
                  _isCenteringLocation = false;
                });
              },
              onLongPress: () {},
              isLoading: _isCenteringLocation,
              currentPosition: _currentPosition)),
    );
  }
}
