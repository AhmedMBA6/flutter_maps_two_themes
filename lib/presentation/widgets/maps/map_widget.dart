import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'loading_widget.dart';

class MapWidget extends StatelessWidget {
  final Position? currentPosition;
  final Completer<GoogleMapController> mapController;
  final Set<Marker> markers;
  final double defaultZoom;

  const MapWidget({
    super.key,
    required this.currentPosition,
    required this.mapController,
    required this.markers,
    required this.defaultZoom,
  });

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      return const LoadingWidget();
    }

    final cameraPosition = CameraPosition(
      target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
      zoom: defaultZoom,
    );

    return RepaintBoundary(
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        onMapCreated: (controller) {
          // Ensure we only complete the completer once
          if (!mapController.isCompleted) {
            mapController.complete(controller);
          }
        },
        myLocationEnabled: false, 
        myLocationButtonEnabled: false, 
        markers: markers,
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
