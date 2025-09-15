import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlacesWebServices {
  late Dio dio;
  static const String baseUrl = "https://places.googleapis.com/v1";
  static const String getPlacesUrl = "$baseUrl/places:autocomplete";

  PlacesWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> fetchSuggestions(
      String place, String sessionToken) async {
    try {
      final apiKey = dotenv.env['GOOGLE_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("Google API Key not found in .env");
      }

      final response = await dio.post(
        getPlacesUrl,
        data: {
          "input": place,
          "sessionToken": sessionToken,
          "locationBias": {
            "circle": {
              "center": {"latitude": 30.0444, "longitude": 31.2357}, // Cairo
              "radius": 50000
            }
          }
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "X-Goog-Api-Key": apiKey,
            "X-Goog-FieldMask":
                "suggestions.placePrediction.placeId,suggestions.placePrediction.text"
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['suggestions'];
      } else {
        throw Exception("Failed to load suggestions: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching suggestions: $e");
    }
  }
}
