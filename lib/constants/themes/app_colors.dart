// lib/constants/themes/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const primary = Color(0xFF3B82F6);
  static const primaryHover = Color(0xFF2563EB);
  static const primaryLight = Color(0xFFEFF6FF);
  static const primaryMedium = Color(0xFFDBEAFE);

  // Semantic
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = primary;

  // Feature Icon Colors
  static const discoverPlacesIcon = Color(0xFF3B82F6); // Blue
  static const discoverPlacesBg = Color(0xFFEFF6FF); // Light blue background
  static const getDirectionsIcon = Color(0xFF10B981); // Green
  static const getDirectionsBg = Color(0xFFECFDF5); // Light green background
  static const saveFavoritesIcon = Color(0xFF8B5CF6); // Purple
  static const saveFavoritesBg = Color(0xFFF5F3FF); // Light purple background

  // Gray scale (light mode base)
  static const gray50 = Color(0xFFF9FAFB);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray500 = Color(0xFF6B7280);
  static const gray600 = Color(0xFF4B5563);
  static const gray700 = Color(0xFF374151);
  static const gray800 = Color(0xFF1F2937);
  static const gray900 = Color(0xFF111827);

  // Theme-Neutral
  static const backgroundLight = Color(0xFFF8FBFF);
  static const foregroundLight = gray900;
  static const cardLight = Colors.white;
  static const borderLight = gray200;
  static const inputBackgroundLight = gray50;

  static const darkScaffoldColor = Color(0xFF0E1C30);
  static const darkGradientStart = Color(0xFF1B2943);
  static const darkGradientEnd = Color(0xFF0E1C30);
  static const foregroundDark = gray800;
  static const cardDark = gray800;
  static const borderDark = gray200;
  static const inputBackgroundDark = gray100;

  // Category Colors (shared across themes)
  static const landmark = Color(0xFFEA580C);
  static const landmarkBg = Color(0xFFFFF7ED);
  static const landmarkBorder = Color(0xFFFED7AA);

  static const tourist = Color(0xFF9333EA);
  static const touristBg = Color(0xFFFAF5FF);
  static const touristBorder = Color(0xFFE9D5FF);

  static const historical = Color(0xFFD97706);
  static const historicalBg = Color(0xFFFFFBEB);
  static const historicalBorder = Color(0xFFFED7AA);

  static const street = Color(0xFF2563EB);
  static const streetBg = Color(0xFFEFF6FF);
  static const streetBorder = Color(0xFFDBEAFE);

  static const neighborhood = Color(0xFF059669);
  static const neighborhoodBg = Color(0xFFECFDF5);
  static const neighborhoodBorder = Color(0xFFA7F3D0);

  static const shopping = Color(0xFFDB2777);
  static const shoppingBg = Color(0xFFFDF2F8);
  static const shoppingBorder = Color(0xFFFBCFE8);

  static const park = Color(0xFF047857);
  static const parkBg = Color(0xFFECFDF5);
  static const parkBorder = Color(0xFFA7F3D0);

  static const architecture = Color(0xFF7C3AED);
  static const architectureBg = Color(0xFFF5F3FF);
  static const architectureBorder = Color(0xFFDDD6FE);
}
