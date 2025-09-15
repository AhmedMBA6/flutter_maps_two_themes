import 'package:flutter/material.dart';
import 'section_header.dart';
import 'favorite_item.dart';
import '../shared_models.dart';

class FavoritesSection extends StatelessWidget {
  const FavoritesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Favorite Places',
            subtitle: '3 saved locations',
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: _buildFavoritesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      itemCount: SamplePlaces.favoritePlaces.length,
      itemBuilder: (context, index) {
        return FavoriteItem(place: SamplePlaces.favoritePlaces[index]);
      },
    );
  }
}
