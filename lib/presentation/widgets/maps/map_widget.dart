import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapsCubit>();

    // Use last known position from Cubit (set when location loads)
    final initialLatLng = cubit.lastKnownPosition != null
        ? LatLng(cubit.lastKnownPosition!.latitude,
            cubit.lastKnownPosition!.longitude)
        : const LatLng(30.0444, 31.2357); // Cairo fallback

    return BlocConsumer<MapsCubit, MapsState>(
      listener: (context, state) async {
                  final cubit = context.read<MapsCubit>();

                  if (state is MapsLocationLoaded && state.shouldCenterCamera) {
                    await cubit.centerCameraOnPosition(state.position);
                  }
      },
      buildWhen: (prev, curr) => curr is MapMarkersUpdated,
      builder: (context, state) {
        final markers = (state is MapMarkersUpdated)
            ? state.markers
            : cubit.placeMarkers;

        return GoogleMap(
          initialCameraPosition:
              CameraPosition(target: initialLatLng, zoom: widget.defaultZoom),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: true,
          markers: markers,
          onMapCreated: (controller) {
              cubit.setMapController(controller);
            },
          onTap: (pos) {
            debugPrint("🗺️ Map tapped at: $pos");
            debugPrint("📍 Current markers count: ${markers.length}");
          },
        );
      },
    );
  }
}
