import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  /// Check if location services are enabled and permissions are granted
  static Future<bool> hasLocationPermission() async {
    try {
      // Check if location service is enabled
      if (!await Geolocator.isLocationServiceEnabled()) {
        return false;
      }

      // Check and request permission if needed
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Get current location with timeout
  static Future<Position?> getCurrentLocation({
    Duration timeout = const Duration(seconds: 10),
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeout,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get last known position (cached location)
  static Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  /// Get best available position (cached first, then current)
  static Future<Position?> getBestPosition({
    Duration timeout = const Duration(seconds: 5),
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    try {
      // Try cached location first (fastest)
      final cached = await getLastKnownPosition();
      if (cached != null) return cached;

      // Fallback to current location
      return await getCurrentLocation(timeout: timeout, accuracy: accuracy);
    } catch (e) {
      return null;
    }
  }

  /// Stream of position updates
  static Stream<Position> getPositionStream({
    int distanceFilter = 50, // meters
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) {
    try {
      return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          distanceFilter: distanceFilter,
        ),
      );
    } catch (e) {
      // Return empty stream if there's an error
      return const Stream.empty();
    }
  }

  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }

  /// Get current permission status
  static Future<LocationPermission> getPermissionStatus() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      return LocationPermission.denied;
    }
  }

  /// Open location settings
  static Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } catch (e) {
      return false;
    }
  }

  /// Open app settings
  static Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      return false;
    }
  }

  /// Calculate distance between two positions
  static double calculateDistance(Position start, Position end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  /// Check if two positions are close to each other
  static bool isNearby(Position pos1, Position pos2, {double thresholdMeters = 100}) {
    final distance = calculateDistance(pos1, pos2);
    return distance <= thresholdMeters;
  }
}
