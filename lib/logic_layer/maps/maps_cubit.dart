import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../helpers/location_helper.dart';
import '../../data_layer/repos/map/maps_repo.dart';
import '../../data_layer/models/map/place_details.dart';
import '../../data_layer/models/map/place_suggestion.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final MapsRepository mapsRepository;

  MapsCubit(this.mapsRepository) : super(MapsInitial());

  GoogleMapController? controller;
  final Set<Marker> placeMarkers = {};
  StreamSubscription<Position>? _locationSub;
  Position? lastKnownPosition;
  bool _controllerReady = false;
  Timer? _debounce;

  // ───────────────────────────────────────────────
  // MARK:  Map Controller
  // ───────────────────────────────────────────────
  void setMapController(GoogleMapController mapController) {
    controller = mapController;
    _controllerReady = true;
    if (kDebugMode) print('🧭 Map controller ready');
  }

  // ───────────────────────────────────────────────
  // MARK:  Location Initialization
  // ───────────────────────────────────────────────
  Future<void> initializeLocation() async {
    emit(MapsLoading());
    try {
      final hasPermission = await LocationHelper.hasLocationPermission();
      if (!hasPermission) {
        emit(MapsError('Location permission required.'));
        return;
      }

      var position = await LocationHelper.getLastKnownPosition();
      if (position == null || _isOld(position)) {
        position = await LocationHelper.getCurrentLocation(
          timeout: const Duration(seconds: 8),
        );
      }

      if (position != null) {
        lastKnownPosition = position;
        emit(MapsLocationLoaded(position, shouldCenterCamera: true));
        _startLocationStream();
      } else {
        emit(MapsError('Unable to fetch location.'));
      }
    } catch (e) {
      emit(MapsError('Failed to init location: $e'));
    }
  }

  void _startLocationStream() {
    _locationSub?.cancel();
    _locationSub = LocationHelper.getPositionStream(distanceFilter: 10).listen(
        (pos) => emit(MapsLocationLoaded(pos)),
        onError: (_) => emit(MapsError('Location stream error')));
  }

  // ───────────────────────────────────────────────
  // MARK:  Camera Helpers
  // ───────────────────────────────────────────────
  Future<void> centerCameraOnPosition(Position pos, {double zoom = 17}) async {
    if (!_controllerReady) return;
    if (controller == null) return;
    final target = LatLng(pos.latitude, pos.longitude);
    await controller!.animateCamera(CameraUpdate.newLatLngZoom(target, zoom));
  }

  Future<void> centerCameraOnLatLng(LatLng target, {double zoom = 17}) async {
    if (controller == null) return;
    await controller!.animateCamera(CameraUpdate.newLatLngZoom(target, zoom));
  }

  // ───────────────────────────────────────────────
  // MARK:  User Location
  // ───────────────────────────────────────────────
  Future<void> centerOnUserLocation() async {
    final pos = await LocationHelper.getCurrentLocation(
      timeout: const Duration(seconds: 5),
    );
    if (pos != null) {
      await centerCameraOnPosition(pos);
      emit(MapsLocationLoaded(pos, shouldCenterCamera: true));
    } else {
      emit(MapsMessage('Unable to get current location.'));
    }
  }

  // ───────────────────────────────────────────────
  // MARK:  Marker Management
  // ───────────────────────────────────────────────
  void addToMarkers(Marker marker, {String? categoryPrefix}) {
    if (categoryPrefix != null) {
      placeMarkers
          .removeWhere((m) => m.markerId.value.startsWith(categoryPrefix));
    } else {
      placeMarkers.removeWhere((m) => m.markerId == marker.markerId);
    }
    placeMarkers.add(marker);
    emit(MapMarkersUpdated(Set.of(placeMarkers)));
    if (kDebugMode) {
      print("✅ Total markers: ${placeMarkers.length}");
    }
  }


  Future<void> addCurrentLocationMarker(Position position) async {
  try {
    final userMarker = Marker(
      markerId: const MarkerId('user_location'),
      position: LatLng(position.latitude, position.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: const InfoWindow(title: 'Your Location'),
      flat: true,
    );

    addToMarkers(userMarker, categoryPrefix: 'user_location');

    if (kDebugMode) {
      print("📍 Added user location marker at: ${position.latitude}, ${position.longitude}");
    }
  } catch (e) {
    emit(MapsError('Failed to add user marker: $e'));
  }
}


  Future<void> setSearchedPlaceMarker(
    Marker searched, {
    bool moveCamera = false,
    double zoom = 17,
  }) async {
    try {
      //  Move camera first (if requested)
      if (moveCamera) {
        await centerCameraOnLatLng(searched.position, zoom: zoom);
      }

      // Manage markers
      addToMarkers(searched, categoryPrefix: 'searched_place_');

      // Update reference (optional continuity)
      lastKnownPosition = Position(
        latitude: searched.position.latitude,
        longitude: searched.position.longitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        headingAccuracy: 0,
        altitudeAccuracy: 0,
      );

      if (kDebugMode) {
        print('📍 Marker added at ${searched.position}');
      }
    } catch (e) {
      emit(MapsError('Failed to set searched marker: $e'));
    }
  }

 /// Handle search query
  void handleSearchQuery(String query) {
    final sessionToken = const Uuid().v4();
    if (query.isNotEmpty) {
      emitPlaceSuggestions(query, sessionToken);
    } else {
      emitClearSuggestions();
    }
  }

  // ───────────────────────────────────────────────
  // MARK:  Suggestions & Place Details
  // ───────────────────────────────────────────────
  Future<void> emitPlaceSuggestions(String query, String sessionToken) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final suggestions =
            await mapsRepository.fetchPlaceSuggestions(query, sessionToken);
        emit(PlaceSuggestionsLoaded(suggestions));
      } catch (e) {
        emit(MapsError('Failed to fetch suggestions: $e'));
      }
    });
  }

  void emitClearSuggestions() => emit(PlaceSuggestionsCleared());

  Future<void> emitPlaceDetails(String placeId, String sessionToken) async {
    try {
      emit(MapsLoading());
      final details =
          await mapsRepository.fetchPlaceDetails(placeId, sessionToken);
      emit(PlaceDetailsLoaded(details));
    } catch (e) {
      emit(MapsError('Failed to load place details: $e'));
    }
  }

  // ───────────────────────────────────────────────
  // MARK:  Utils
  // ───────────────────────────────────────────────
  bool _isOld(Position p) =>
      DateTime.now().difference(p.timestamp).inMinutes > 5;

  @override
  Future<void> close() {
    _locationSub?.cancel();
    return super.close();
  }
}
