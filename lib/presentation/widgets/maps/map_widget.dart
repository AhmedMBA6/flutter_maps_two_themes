import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'loading_widget.dart';

class MapWidget extends StatelessWidget {
  final Position? currentPosition;
  final Completer<GoogleMapController> mapController;
  final double defaultZoom;
  final Set<Marker> markers;

  const MapWidget({
    super.key,
    required this.currentPosition,
    required this.mapController,
    required this.defaultZoom,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      return const LoadingWidget();
    }

    final cameraPosition = CameraPosition(
      target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
      bearing: 0,
      tilt: 0,
      zoom: defaultZoom,
    );

    return RepaintBoundary(
      child: GoogleMap(
        markers: markers,
        initialCameraPosition: cameraPosition,
        onMapCreated: (controller) {
          // Ensure we only complete the completer once
          if (!mapController.isCompleted) {
            mapController.complete(controller);
          }
        },
        onTap: (pos) {
          print("🗺️ Map tapped at: $pos");
          print("📍 Current markers count: ${markers.length}");
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        compassEnabled: true,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        // Performance optimizations
        liteModeEnabled: false,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
        // Additional stability options
        indoorViewEnabled: false,
        trafficEnabled: false,
        buildingsEnabled: true,
      ),
    );
  }
}
