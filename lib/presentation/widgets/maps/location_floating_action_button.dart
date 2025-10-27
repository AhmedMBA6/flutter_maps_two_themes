import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../logic_layer/maps/maps_cubit.dart';

class LocationFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final bool isLoading;
  final Position? currentPosition;

  const LocationFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.onLongPress,
    required this.isLoading,
     this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    return  RepaintBoundary(
      child: BlocBuilder<MapsCubit, MapsState>(
          builder: (context, state) {
            final hasPosition =
                currentPosition != null || state is MapsLocationLoaded;

            if (!hasPosition) {
              return const SizedBox.shrink();
            }

            return GestureDetector(
        onLongPress: onLongPress,
        child: FloatingActionButton(
          onPressed: isLoading ? null : onPressed,
          tooltip: 'Center on my location (long press to refresh)',
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          child: isLoading 
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Icon(Icons.my_location),
        ),
      );
          },
        ), 
    );
  }
}
