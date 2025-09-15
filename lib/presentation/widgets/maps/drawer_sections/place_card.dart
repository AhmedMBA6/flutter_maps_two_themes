import 'package:flutter/material.dart';
import '../../../../constants/themes/app_colors.dart';
import '../shared_models.dart';

class PlaceCard extends StatelessWidget {
  final PlaceData place;

  const PlaceCard({
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
        ],
      ),
    );
  }

  Widget _buildPlaceImage() {
    return Container(
      width: 60,
      height: 60,
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
                size: 24,
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
        // Place name
        Text(
          place.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 4),
        
        // Location
        Text(
          place.location,
          style: const TextStyle(
            color: AppColors.gray400,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 8),
        
        // Category tag and rating
        _buildCategoryAndRating(),
      ],
    );
  }

  Widget _buildCategoryAndRating() {
    return Row(
      children: [
        // Category tag
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: place.categoryBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: place.categoryColor,
              width: 1,
            ),
          ),
          child: Text(
            place.category,
            style: TextStyle(
              color: place.categoryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        const Spacer(),
        
        // Rating
        Row(
          children: [
            const Icon(
              Icons.star,
              color: AppColors.warning,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              place.rating.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        const SizedBox(width: 12),
        
        // Cost
        Text(
          place.cost,
          style: const TextStyle(
            color: AppColors.gray400,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
