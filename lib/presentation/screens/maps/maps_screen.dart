import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:uuid/uuid.dart';
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
  Position? _currentPosition;
 bool _isCenteringLocation = false;
  late Marker currentLocationMarker;

  // Constants
  //static const MarkerId _userMarkerId = MarkerId('user_location');
  static const double _defaultZoom = 17.0;
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

  /// Handle search query
  void _handleSearchQuery(String query) {
    final sessionToken = const Uuid().v4();
    final cubit = context.read<MapsCubit>();

    if (query.isNotEmpty) {
      cubit.emitPlaceSuggestions(query, sessionToken);
    } else {
      cubit.emitClearSuggestions();
    }
  }

  void buildCurrentLocationMarker() async {
    currentLocationMarker = Marker(
      markerId: const MarkerId('user_location'),
      position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: const InfoWindow(title: 'Your Location'),
      flat: true,
    );
    context.read<MapsCubit>().buildCurrentLocationMarker(currentLocationMarker);
  }

  @override
  Widget build(BuildContext context) {
    final mapsCubit = context.read<MapsCubit>();
    return SafeArea(
      child: Scaffold(
        drawer: const AppDrawer(),
        body: RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              BlocConsumer<MapsCubit, MapsState>(buildWhen: (previous, current) => current is MapsLoading || current is MapsError || current is MapMarkersUpdated || current is MapsLocationLoaded,
               listenWhen: (previous, current) => current is MapsLocationLoaded, builder: (context, state) {
                if (state is MapsLoading){
                  return const LoadingWidget();
                } if (state is MapsError) {
                  return MapErrorWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<MapsCubit>().initializeLocation();
                    },
                  );
                }
                final position = (state is MapsLocationLoaded) ? state.position : _currentPosition;
                final markers = (state is MapMarkersUpdated)
                    ? state.markers
                    : mapsCubit.placeMarkers;
                return MapWidget(
                              currentPosition: position,
                              mapController: _mapController,
                              markers: markers,
                              defaultZoom: _defaultZoom,
                            );
                
               }, listener: (context, state) async{ if (state is MapsLocationLoaded && state.shouldCenterCamera) {
                _currentPosition = state.position;
                await mapsCubit.centerCameraOnPosition(state.position);
                
                  buildCurrentLocationMarker();
                }}),
                MapFloatingSearchBar(
                onTap: buildCurrentLocationMarker,
                controller: _searchController,
                mapController: _mapController,
                onRecentSearches: () {
                  // Handle recent searches
                },
                onSavedPlaces: () {
                  // Handle saved places
                },
                onQueryChanged: _handleSearchQuery,
              ),
            ],
          ),
        ),

        floatingActionButton: BlocBuilder<MapsCubit, MapsState>(
          builder: (context, state) {
            final hasPosition = _currentPosition != null || state is MapsLocationLoaded;

            if (!hasPosition) {
              return const SizedBox.shrink();
          }

          return LocationFloatingActionButton(
                onPressed: () async{
                  setState(() {
                    _isCenteringLocation = true ; 
                  });
                  await mapsCubit.centerOnUserLocation();
                  setState(() {
                    _isCenteringLocation = false ; 
                  });
                },
                onLongPress: () => mapsCubit.refreshLocation(),
                isLoading: _isCenteringLocation,
              );
          },
        ),
      ),
    );
  }
}
