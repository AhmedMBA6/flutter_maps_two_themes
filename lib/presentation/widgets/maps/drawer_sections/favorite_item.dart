import 'package:flutter/material.dart';
import '../../../../constants/themes/app_colors.dart';
import '../shared_models.dart';

class FavoriteItem extends StatelessWidget {
  final PlaceData place;

  const FavoriteItem({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderDark,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Place image
          _buildPlaceImage(),
          
          const SizedBox(width: 12),
          
          // Place details
          Expanded(
            child: _buildPlaceDetails(),
          ),
          
          // Favorite icon
          _buildFavoriteIcon(),
        ],
      ),
    );
  }

  Widget _buildPlaceImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.gray700,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          place.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.gray600,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.place,
                color: AppColors.gray400,
                size: 20,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          place.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          place.location,
          style: const TextStyle(
            color: AppColors.gray400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteIcon() {
    return IconButton(
      icon: const Icon(
        Icons.favorite,
        color: AppColors.error,
        size: 20,
      ),
      onPressed: () {},
    );
  }
}
