import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';

class PlaceData {
  final String name;
  final String location;
  final String category;
  final double rating;
  final String cost;
  final String imageUrl;
  final Color categoryColor;
  final Color categoryBgColor;

  PlaceData({
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    required this.cost,
    required this.imageUrl,
    required this.categoryColor,
    required this.categoryBgColor,
  });
}

// Sample data for different categories
class SamplePlaces {
  static final List<PlaceData> nearbyPlaces = [
    PlaceData(
      name: 'Golden Gate Bridge',
      location: 'Golden Gate Bridge, San Francisco',
      category: 'Landmark',
      rating: 4.8,
      cost: 'Free',
      imageUrl: 'assets/icons/landmark_placeholder.png',
      categoryColor: AppColors.landmark,
      categoryBgColor: AppColors.landmarkBg,
    ),
    PlaceData(
      name: 'Fisherman\'s Wharf',
      location: 'Fisherman\'s Wharf, San Francisco',
      category: 'Tourist Attraction',
      rating: 4.7,
      cost: 'Free',
      imageUrl: 'assets/icons/tourist_placeholder.png',
      categoryColor: AppColors.tourist,
      categoryBgColor: AppColors.touristBg,
    ),
    PlaceData(
      name: 'Alcatraz Island',
      location: 'Alcatraz Island, San Francisco',
      category: 'Historical Site',
      rating: 4.6,
      cost: '\$',
      imageUrl: 'assets/icons/historical_placeholder.png',
      categoryColor: AppColors.historical,
      categoryBgColor: AppColors.historicalBg,
    ),
    PlaceData(
      name: 'Lombard Street',
      location: 'Lombard Street, San Francisco',
      category: 'Street',
      rating: 4.2,
      cost: 'Free',
      imageUrl: 'assets/icons/street_placeholder.png',
      categoryColor: AppColors.street,
      categoryBgColor: AppColors.streetBg,
    ),
    PlaceData(
      name: 'Chinatown',
      location: 'Chinatown, San Francisco, CA',
      category: 'Neighborhood',
      rating: 4.4,
      cost: 'Free',
      imageUrl: 'assets/icons/neighborhood_placeholder.png',
      categoryColor: AppColors.neighborhood,
      categoryBgColor: AppColors.neighborhoodBg,
    ),
    PlaceData(
      name: 'Union Square',
      location: 'Union Square, San Francisco',
      category: 'Shopping',
      rating: 4.3,
      cost: '\$',
      imageUrl: 'assets/icons/shopping_placeholder.png',
      categoryColor: AppColors.shopping,
      categoryBgColor: AppColors.shoppingBg,
    ),
  ];

  static final List<PlaceData> favoritePlaces = [
    PlaceData(
      name: 'Golden Gate Bridge',
      location: 'Golden Gate Bridge, San Francisco',
      category: 'Landmark',
      rating: 4.8,
      cost: 'Free',
      imageUrl: 'assets/icons/landmark_placeholder.png',
      categoryColor: AppColors.landmark,
      categoryBgColor: AppColors.landmarkBg,
    ),
    PlaceData(
      name: 'Fisherman\'s Wharf',
      location: 'Fisherman\'s Wharf, San Francisco',
      category: 'Tourist Attraction',
      rating: 4.7,
      cost: 'Free',
      imageUrl: 'assets/icons/tourist_placeholder.png',
      categoryColor: AppColors.tourist,
      categoryBgColor: AppColors.touristBg,
    ),
    PlaceData(
      name: 'Alcatraz Island',
      location: 'Alcatraz Island, San Francisco',
      category: 'Historical Site',
      rating: 4.6,
      cost: '\$',
      imageUrl: 'assets/icons/historical_placeholder.png',
      categoryColor: AppColors.historical,
      categoryBgColor: AppColors.historicalBg,
    ),
  ];

  static final List<String> searchHistory = [
    'Golden Gate Bridge',
    'Fisherman\'s Wharf',
    'Alcatraz Island',
    'Lombard Street',
    'Chinatown',
  ];
}
