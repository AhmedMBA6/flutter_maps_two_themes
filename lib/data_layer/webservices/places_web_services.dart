import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class PlacesWebServices {
  late Dio dio;
  static const String baseUrl = "https://places.googleapis.com/v1";
  static const String getPlacesUrl = "$baseUrl/places:autocomplete";
  static const String getPlaceDetailsUrl = "$baseUrl/places/";
  static const String directionsUrl =
      "https://routes.googleapis.com/directions/v2:computeRoutes";
  final apiKey = dotenv.env['GOOGLE_API_KEY'];

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
      if (apiKey == null || apiKey!.isEmpty) {
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
      if (apiKey == null || apiKey!.isEmpty) {
        throw Exception("Google API Key not found in .env");
      }

      final response = await dio.get("$getPlaceDetailsUrl$placeId",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "X-Goog-Session-Token": sessionToken,
              "X-Goog-Api-Key": apiKey,
              "X-Goog-FieldMask": 'id,displayName,location,formattedAddress',
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

  Future<dynamic> fetchDirections(LatLng origin, LatLng destination) async {
    try {
      if (apiKey == null || apiKey!.isEmpty) {
        throw Exception("Google API Key not found in .env");
      }
      Response response = await dio.post(
        directionsUrl,
        data: {
          "origin": {
            "location": {
              "latLng": {
                "latitude": origin.latitude,
                "longitude": origin.longitude
              }
            }
          },
          "destination": {
            "location": {
              "latLng": {
                "latitude": destination.latitude,
                "longitude": destination.longitude
              }
            }
          },
          "travelMode": "DRIVE",
          "routingPreference": "TRAFFIC_AWARE",
          "computeAlternativeRoutes": false,
          "routeModifiers": {
            "avoidTolls": false,
            "avoidHighways": false,
            "avoidFerries": false
          },
          "languageCode": "en-US",
          "units": "METRIC"
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "X-Goog-Api-Key": apiKey,
            "X-Goog-FieldMask":
                // "routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline"
                "routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline,routes.legs.startLocation,routes.legs.endLocation,routes.legs.distanceMeters,routes.legs.duration,routes.travelAdvisory,routes.legs.steps.polyline.encodedPolyline"
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load place details: ${response.statusCode}");
      }
    } catch (error) {
      return Future.error(
          "Directions ERROR: ", StackTrace.fromString(("this is its trace")));
    }
  }
}
