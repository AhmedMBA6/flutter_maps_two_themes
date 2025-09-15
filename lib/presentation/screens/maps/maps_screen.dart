import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:uuid/uuid.dart';
import '../../../helpers/location_helper.dart';
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
  bool _isLoading = true;
  bool _hasInitialized = false;
  String? _errorMessage;
  bool _isCenteringLocation = false;

  // Stream subscription
  StreamSubscription<Position>? _locationSubscription;

  // Constants
  static const MarkerId _userMarkerId = MarkerId('user_location');
  static const double _defaultZoom = 17.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  /// Initialize location services and start tracking
  Future<void> _initializeLocation() async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Check permissions
      final hasPermission = await LocationHelper.hasLocationPermission();
      if (!hasPermission) {
        _setError(
            'Location permission required. Please enable location services.');
        return;
      }

      // Get initial position with multiple attempts
      Position? position;

      // First try cached position (fastest)
      position = await LocationHelper.getLastKnownPosition();

      // If no cached position or it's too old, get fresh position
      if (position == null || _isPositionOld(position)) {
        position = await LocationHelper.getCurrentLocation(
          timeout: const Duration(seconds: 8),
        );
      }

      if (mounted && position != null) {
        _updatePosition(position, centerCamera: true);
      } else {
        _setError(
            'Unable to get your location. Please check your GPS settings.');
      }

      // Start location stream
      _startLocationStream();
    } catch (e) {
      if (mounted) {
        _setError('Failed to initialize location services: $e');
      }
    }
  }

  /// Check if position is too old (more than 5 minutes)
  bool _isPositionOld(Position position) {
    final now = DateTime.now();
    final positionTime = position.timestamp;

    final difference = now.difference(positionTime);
    return difference.inMinutes > 5;
  }

  /// Set error state
  void _setError(String message) {
    if (!mounted) return;
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  /// Start listening to location updates
  void _startLocationStream() {
    _locationSubscription?.cancel();
    _locationSubscription = LocationHelper.getPositionStream(
      distanceFilter: 10,
    ).listen(
      (position) {
        if (mounted) {
          _updatePosition(position);
        }
      },
      onError: (error) {
        if (mounted) {
          _setError('Location update failed. Please check your connection.');
        }
      },
    );
  }

  /// Update position and optionally center camera
  void _updatePosition(Position position, {bool centerCamera = false}) {
    if (!mounted) return;

    setState(() {
      _currentPosition = position;
      _isLoading = false;
      _errorMessage = null;
      _hasInitialized = true;
    });

    // Center camera on first position or when requested
    if (centerCamera || !_hasInitialized) {
      _centerCameraOnPosition(position);
    }
  }

  /// Check if map controller is ready
  bool get _isMapControllerReady => _mapController.isCompleted;

  /// Center camera on specific position
  Future<void> _centerCameraOnPosition(Position position) async {
    try {
      // Check if controller is ready
      if (!_isMapControllerReady) {
        // Wait for controller to be ready with timeout
        try {
          await _mapController.future.timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              throw Exception('Map controller timeout');
            },
          );
        } catch (e) {
          _showMessage('Map is still loading. Please wait a moment.');
          return;
        }
      }

      final controller = await _mapController.future;
      final latLng = LatLng(position.latitude, position.longitude);

      // Use moveCamera instead of animateCamera for more reliable operation
      await controller.moveCamera(
        CameraUpdate.newLatLngZoom(latLng, _defaultZoom),
      );
    } catch (e) {
      // Handle specific platform exceptions
      if (e.toString().contains('PlatformException')) {
        _showMessage('Map operation failed. Please try again.');
      } else {
        _showMessage(
            'Failed to center camera: ${e.toString().split(':').last.trim()}');
      }
    }
  }

  /// Center camera on current user location
  Future<void> _centerOnUserLocation() async {
    // Prevent multiple rapid taps
    if (_isCenteringLocation) {
      _showMessage('Already centering location...');
      return;
    }

    try {
      setState(() {
        _isCenteringLocation = true;
      });

      // Check if we have a valid position
      if (_currentPosition == null) {
        _showMessage('Getting your location...');

        // Try to get fresh location
        final position = await LocationHelper.getCurrentLocation(
          timeout: const Duration(seconds: 5),
        );

        if (mounted && position != null) {
          _updatePosition(position, centerCamera: true);
          _showMessage('Location updated and centered');
        } else {
          _showMessage(
              'Unable to get current location. Please check your GPS.');
        }
        return;
      }

      // Use cached position if available
      await _centerCameraOnPosition(_currentPosition!);
      _showMessage('Centered on your location');
    } catch (e) {
      if (e.toString().contains('PlatformException')) {
        _showMessage('Map operation failed. Please try again.');
      } else {
        _showMessage(
            'Failed to center on location: ${e.toString().split(':').last.trim()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCenteringLocation = false;
        });
      }
    }
  }

  /// Manually refresh location and center camera
  Future<void> _refreshLocation() async {
    try {
      _showMessage('Refreshing location...');

      final position = await LocationHelper.getCurrentLocation(
        timeout: const Duration(seconds: 8),
      );

      if (mounted && position != null) {
        _updatePosition(position, centerCamera: true);
        _showMessage('Location refreshed and centered');
      } else {
        _showMessage('Failed to refresh location. Please check your GPS.');
      }
    } catch (e) {
      if (e.toString().contains('PlatformException')) {
        _showMessage('Map operation failed. Please try again.');
      } else {
        _showMessage(
            'Failed to refresh location: ${e.toString().split(':').last.trim()}');
      }
    }
  }

  /// Show message to user
  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _locationSubscription?.pause();
    } else if (state == AppLifecycleState.resumed) {
      _locationSubscription?.resume();
    }
  }

  /// Build markers for the map
  Set<Marker> _buildMarkers() {
    if (_currentPosition == null) return {};

    return {
      Marker(
        markerId: _userMarkerId,
        position:
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Your Location'),
        flat: true,
        zIndexInt: 1,
      ),
    };
  }

  /// Handle search query
  void _handleSearchQuery(String query) {
    final sessionToken = const Uuid().v4();

    if (query.isNotEmpty) {
      BlocProvider.of<MapsCubit>(context)
          .emitPlaceSuggestions(query, sessionToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const AppDrawer(),
        body: RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Map or loading/error state
              _isLoading
                  ? const LoadingWidget()
                  : _errorMessage != null
                      ? MapErrorWidget(
                          message: _errorMessage!,
                          onRetry: _initializeLocation,
                        )
                      : MapWidget(
                          currentPosition: _currentPosition,
                          mapController: _mapController,
                          markers: _buildMarkers(),
                          defaultZoom: _defaultZoom,
                        ),

              // Floating search bar
              MapFloatingSearchBar(
                controller: _searchController,
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
        floatingActionButton: _currentPosition != null
            ? LocationFloatingActionButton(
                onPressed: _centerOnUserLocation,
                onLongPress: _refreshLocation,
                isLoading: _isCenteringLocation,
              )
            : null,
      ),
    );
  }
}
