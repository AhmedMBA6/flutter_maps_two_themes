import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data_layer/models/map/place_details.dart';
import '../../data_layer/models/map/place_suggestion.dart';
import '../../data_layer/repos/map/maps_repo.dart';
import '../../helpers/location_helper.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final MapsRepository mapsRepository;
  final Set<Marker> placeMarkers = <Marker>{};
  Set<Marker> get markers => placeMarkers;
  GoogleMapController? controller;
  MapsCubit(this.mapsRepository) : super(MapsInitial());
  StreamSubscription<Position>? _locationSubscription;

  void setMapController(GoogleMapController mapController) {
    controller = mapController;
    if (kDebugMode) print("🧭 Map controller set successfully.");
  }

  Future<void> initializeLocation() async {
    emit(MapsLoading());

    try {
      final hasPermission = await LocationHelper.hasLocationPermission();
      if (!hasPermission) {
        emit(MapsError(
            "Location permission required. Enable location services."));
        return;
      }

      Position? position = await LocationHelper.getLastKnownPosition();
      if (position == null || _isPositionOld(position)) {
        position = await LocationHelper.getCurrentLocation(
          timeout: const Duration(seconds: 8),
        );
      }

      if (position != null) {
        emit(MapsLocationLoaded(position, shouldCenterCamera: true));
        _startLocationStream();
      } else {
        emit(
            MapsError("Unable to get your location. Check your GPS settings."));
      }
    } catch (e) {
      emit(MapsError("Failed to initialize location: $e"));
    }
  }

  void _startLocationStream() {
    _locationSubscription?.cancel();
    _locationSubscription = LocationHelper.getPositionStream(
      distanceFilter: 10,
    ).listen((position) {
      emit(MapsLocationLoaded(position));
    }, onError: (error) {
      emit(MapsError("Location update failed."));
    });
  }

  Future<void> centerOnUserLocation() async {
    final pos = await LocationHelper.getCurrentLocation(
      timeout: const Duration(seconds: 5),
    );
    if (pos != null) {
      emit(MapsLocationLoaded(pos, shouldCenterCamera: true));
    } else {
      emit(MapsMessage("Unable to get current location."));
    }
  }

  Future<void> centerCameraOnPosition(Position position, {double zoom = 17.0}) async {
    if (controller == null) {
    if (kDebugMode) print("⚠️ Map controller is not yet available.");
    return;
  }
  final target = LatLng(position.latitude, position.longitude);
  try {
    await controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
    if (kDebugMode) {
      print("📍 Camera centered on: ${position.latitude}, ${position.longitude}");
    }
  } catch (e) {
    if (kDebugMode) print("❌ Error centering camera: $e");
  }
    emit(MapsLocationLoaded(position, shouldCenterCamera: true));
  }

  Future<void> refreshLocation() async {
    final pos = await LocationHelper.getCurrentLocation(
      timeout: const Duration(seconds: 8),
    );
    if (pos != null) {
      emit(MapsLocationLoaded(pos, shouldCenterCamera: true));
    } else {
      emit(MapsError("Failed to refresh location."));
    }
  }

  bool _isPositionOld(Position position) {
    final now = DateTime.now();
    final positionTime = position.timestamp;
    return now.difference(positionTime).inMinutes > 5;
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }

  void addToMarkers(Marker marker) {
    if (kDebugMode) {
      print("🟣 addToMarkers() called for: ${marker.markerId.value}");
    }
      

      // Remove duplicates by markerId if needed
      placeMarkers.removeWhere((m) => m.markerId == marker.markerId);

      // Add the new marker
      placeMarkers.add(marker);

      // Always create a NEW Set instance to trigger rebuild
       emit(MapMarkersUpdated(Set<Marker>.of(placeMarkers)));

    if (kDebugMode) {
      print("✅ Total markers: ${placeMarkers.length}");
    }
  }

  void setSearchedPlaceMarker(Marker searched) async{
    // Remove any previous searched-place markers
    placeMarkers.removeWhere((m) => m.markerId.value.startsWith('searched_place_'));
    addToMarkers(searched);
    emit(MapMarkersUpdated(Set<Marker>.of(placeMarkers)));
  }

  void buildCurrentLocationMarker(Marker currentLocationMarker) async {
    
    addToMarkers(currentLocationMarker);
  }

  void clearMarkers() {
    placeMarkers.removeWhere((marker) => marker.markerId.value.startsWith('searched_'));
    emit(MapMarkersUpdated(Set<Marker>.of(placeMarkers)));
  }

  void emitPlaceSuggestions(String place, String sessionToken) async {
    mapsRepository
        .fetchPlaceSuggestions(place, sessionToken)
        .then((suggestions) {
      emit(PlaceSuggestionsLoaded(suggestions));
    });
  }

  void emitClearSuggestions() {
    emit(PlaceSuggestionsCleared());
  }

  Future<void> emitPlaceDetails(String placeId, String sessionToken) async {
    try {
      if (kDebugMode) {
        print("🌍 Fetching place details for ID: $placeId");
      }
      emit(MapsLoading());

      final placeDetails =
          await mapsRepository.fetchPlaceDetails(placeId, sessionToken);
      emit(PlaceDetailsLoaded(placeDetails));

      if (kDebugMode) {
        print("✅ Emitting PlaceDetailsLoaded for ${placeDetails.name}");
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('❌ Error fetching place details: $error');
      }
      if (kDebugMode) {
        print(stackTrace);
      }
      emit(MapsError(error.toString()));
    }
  }
}
