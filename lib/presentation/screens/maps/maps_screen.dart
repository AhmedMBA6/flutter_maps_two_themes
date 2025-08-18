import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../helpers/location_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic_layer/auth/auth_cubit.dart';
import '../../../logic_layer/auth/auth_state.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> with WidgetsBindingObserver {
  // Controllers
  final Completer<GoogleMapController> _mapController = Completer();
  
  // State
  Position? _currentPosition;
  bool _isLoading = true;
  bool _hasInitialized = false;
  String? _errorMessage;
  
  // Stream subscription
  StreamSubscription<Position>? _locationSubscription;
  
  // Constants
  static const MarkerId _userMarkerId = MarkerId('user_location');
  static const double _defaultZoom = 16.0;

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
        _setError('Location permission required. Please enable location services.');
        return;
      }


      // Get initial position with multiple attempts
      Position? position;
      
      // First try cached position (fastest)
      position = await LocationHelper.getLastKnownPosition();
      if (position != null) {
      }
      
      // If no cached position or it's too old, get fresh position
      if (position == null || _isPositionOld(position)) {
        position = await LocationHelper.getCurrentLocation(
          timeout: const Duration(seconds: 8),
        );
        if (position != null) {
        }
      }

      if (mounted && position != null) {
        _updatePosition(position, centerCamera: true);
      } else {
        _setError('Unable to get your location. Please check your GPS settings.');
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
      distanceFilter: 10, // Update every 10 meters for better accuracy
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

  /// Center camera on specific position
  Future<void> _centerCameraOnPosition(Position position) async {
    try {
      
      if (!_mapController.isCompleted) {
        // Wait a bit for the controller to be ready
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      final controller = await _mapController.future;
      final latLng = LatLng(position.latitude, position.longitude);
      
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, _defaultZoom),
      );
    } catch (e) {
      _showMessage('Failed to center camera: $e');
    }
  }

  /// Center camera on current user location
  Future<void> _centerOnUserLocation() async {
    try {
      
      // First, try to use current cached position
      if (_currentPosition != null) {
        await _centerCameraOnPosition(_currentPosition!);
        _showMessage('Centered on your location');
        return;
      }

      // If no cached position, try to get fresh location
      _showMessage('Getting fresh location...');
      
      final position = await LocationHelper.getCurrentLocation(
        timeout: const Duration(seconds: 5),
      );
      
      if (mounted && position != null) {
        _updatePosition(position, centerCamera: true);
        _showMessage('Location updated and centered');
      } else {
        _showMessage('Unable to get current location. Please check your GPS.');
      }
    } catch (e) {
      _showMessage('Failed to center on location: $e');
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
      _showMessage('Failed to refresh location: $e');
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

  /// Build the map widget
  Widget _buildMap() {
    if (_currentPosition == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Getting your location...'),
          ],
        ),
      );
    }

    final cameraPosition = CameraPosition(
      target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      zoom: _defaultZoom,
    );

    return GoogleMap(
      initialCameraPosition: cameraPosition,
      onMapCreated: (controller) {
        if (!_mapController.isCompleted) {
          _mapController.complete(controller);
        }
      },
      myLocationEnabled: false, 
      myLocationButtonEnabled: false, 
      markers: _buildMarkers(),
      compassEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  /// Build markers for the map
  Set<Marker> _buildMarkers() {
    if (_currentPosition == null) return {};

    return {
      Marker(
        markerId: _userMarkerId,
        position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    };
  }

  /// Build error widget
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'Location error',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _initializeLocation,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // Handle sign out navigation
          if (state is SignOutSuccess) {
            Navigator.of(context).pushReplacementNamed('/auth');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Maps'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              // Sign out button
              IconButton(
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
                tooltip: 'Sign Out',
              ),
            ],
          ),
          body: _isLoading 
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Initializing map...'),
                  ],
                ),
              )
            : _errorMessage != null
              ? _buildErrorWidget()
              : _buildMap(),
          floatingActionButton: _currentPosition != null ? GestureDetector(
            onLongPress: _refreshLocation,
            child: FloatingActionButton(
              onPressed: _centerOnUserLocation,
              tooltip: 'Center on my location (long press to refresh)',
              child: const Icon(Icons.my_location),
            ),
          ) : null,
        ),
      ),
    );
  }

  /// Sign out the user
  Future<void> _signOut() async {
    try {
      // Show confirmation dialog
      final shouldSignOut = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      );

      if (shouldSignOut == true) {
        // Get the auth cubit and sign out
        final authCubit = context.read<AuthCubit>();
        await authCubit.signOut();
        
        // Navigation will be handled by the BlocListener in InitialRouteHandler
        _showMessage('Signed out successfully');
      }
    } catch (e) {
      _showMessage('Failed to sign out: $e');
    }
  }
}
