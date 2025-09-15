import 'package:flutter/material.dart';
import 'section_header.dart';
import 'place_card.dart';
import '../shared_models.dart';

class MapSection extends StatelessWidget {
  const MapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          const SectionHeader(
            title: 'Nearby Places',
            subtitle: '10 places found',
          ),
          const SizedBox(height: 16),
          
          // Places list
          Expanded(
            child: _buildPlacesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacesList() {
    return ListView.builder(
      itemCount: SamplePlaces.nearbyPlaces.length,
      itemBuilder: (context, index) {
        return PlaceCard(place: SamplePlaces.nearbyPlaces[index]);
      },
    );
  }
}
