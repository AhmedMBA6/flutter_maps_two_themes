import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class PlacesWebServices {
  late Dio dio;
  static const String baseUrl = "https://places.googleapis.com/v1";
  static const String getPlacesUrl = "$baseUrl/places:autocomplete";
  static const String getPlaceDetailsUrl = "$baseUrl/places/";

  PlacesWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          logPrint: (obj) {
            final text = obj.toString().replaceAll(
                RegExp(r'X-Goog-Api-Key:.*'), 'X-Goog-Api-Key: [HIDDEN]');
            if (kDebugMode) {
              print(text);
            }
          },
          error: true,
          compact: true,
          maxWidth: 120,
        ),
      );
    }
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

  Future<dynamic> fetchPlaceDetails(String placeId, String sessionToken) async {
    try {
      final apiKey = dotenv.env['GOOGLE_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("Google API Key not found in .env");
      }

      final response = await dio.get(
        "$getPlaceDetailsUrl$placeId",
        options: Options(headers: {
          "Content-Type": "application/json",
          "X-Goog-Session-Token": sessionToken,
          "X-Goog-Api-Key": apiKey,
          "X-Goog-FieldMask": '*',
        },
      ));

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load place details: ${response.statusCode}");
      }
    } catch (e) {
      return Future.error("Place location error: ",
          StackTrace.fromString(('this is its trace')));
    }
  }
}
