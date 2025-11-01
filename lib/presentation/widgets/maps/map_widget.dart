import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_two_themes/constants/themes/app_colors.dart';
import 'package:flutter_login_two_themes/data_layer/models/map/place_directions.dart';
import 'package:flutter_login_two_themes/presentation/widgets/maps/mode_info_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../logic_layer/maps/maps_cubit.dart';

class MapWidget extends StatefulWidget {
  final double defaultZoom;

  const MapWidget({
    super.key,
    required this.defaultZoom,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  PlaceDirections? placeDirections;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapsCubit>();

    // Use last known position from Cubit (set when location loads)
    final initialLatLng = cubit.lastKnownPosition != null
        ? LatLng(cubit.lastKnownPosition!.latitude,
            cubit.lastKnownPosition!.longitude)
        : const LatLng(30.0444, 31.2357); // Cairo fallback

    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        Set<Polyline> routePolylines = {};

        // Check for DirectionsLoaded and add polyline
        if (state is DirectionsLoaded) {
          placeDirections = state.placeDirections;
          routePolylines.add(Polyline(
            polylineId: const PolylineId('route'),
            points: placeDirections!.polylinePoints
                .map(
                    (point) => LatLng(point[0].toDouble(), point[1].toDouble()))
                .toList(),
            color: AppColors.primary,
            width: 5,
          ));
        }

        if (state is MapMarkersUpdated && cubit.placeMarkers.length < 2) {
          placeDirections = null;
        }

        // Get markers from Cubit or the updated state
        final markers =
            (state is MapMarkersUpdated) ? state.markers : cubit.placeMarkers;

        return Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: initialLatLng, zoom: widget.defaultZoom),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: true,
                markers: markers,
                polylines: routePolylines, // Display polyline here
                onMapCreated: (controller) {
                  cubit.setMapController(controller); // Set the map controller
                },
                onTap: (pos) {
                  debugPrint("🗺️ Map tapped at: $pos");
                  debugPrint("📍 Current markers count: ${markers.length}");
                },
              ),
            ),
            if (placeDirections != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 24, 
                child: AnimatedSlide(
                  offset: placeDirections != null
                      ? Offset.zero
                      : const Offset(0, 2),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: placeDirections != null ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    child: RouteInfoCard(
                      distance:
                          (placeDirections!.distance / 1000).toStringAsFixed(1),
                      duration:
                          placeDirections!.duration.replaceAll('s', ' sec'),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
