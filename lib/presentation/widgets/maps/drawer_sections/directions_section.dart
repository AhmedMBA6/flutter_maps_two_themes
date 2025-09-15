import 'package:flutter/material.dart';
import '../../../../constants/themes/app_colors.dart';
import 'section_header.dart';
import 'direction_input.dart';
import 'transport_option.dart';

class DirectionsSection extends StatelessWidget {
  const DirectionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Get Directions',
            subtitle: 'Plan your route',
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: _buildDirectionsContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionsContent() {
    return Column(
      children: [
        // Input fields
        const DirectionInput(
          label: 'From',
          hint: 'Current location',
          icon: Icons.my_location,
        ),
        const SizedBox(height: 12),
        const DirectionInput(
          label: 'To',
          hint: 'Enter destination',
          icon: Icons.location_on,
        ),
        const SizedBox(height: 20),
        
        // Transport options
        const Text(
          'Transport Mode',
          style: TextStyle(
            color: AppColors.gray400,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        _buildTransportOptions(),
        const SizedBox(height: 20),
        
        // Get directions button
        _buildGetDirectionsButton(),
      ],
    );
  }

  Widget _buildTransportOptions() {
    return Row(
      children: [
        Expanded(
          child: TransportOption(
            icon: Icons.directions_car,
            label: 'Drive',
            isSelected: true,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TransportOption(
            icon: Icons.directions_walk,
            label: 'Walk',
            isSelected: false,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TransportOption(
            icon: Icons.directions_bus,
            label: 'Transit',
            isSelected: false,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildGetDirectionsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Get Directions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
