import 'package:flutter_login_two_themes/data_layer/models/map/place_details.dart';
import 'package:flutter_login_two_themes/data_layer/models/map/place_directions.dart';
import 'package:flutter_login_two_themes/data_layer/models/map/place_suggestion.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../webservices/places_web_services.dart';

class MapsRepository {
  final PlacesWebServices placesWebServices;

  MapsRepository(this.placesWebServices);


  Future<List<PlaceSuggestion>> fetchPlaceSuggestions(String place, String sessionToken) async{
    final suggestions = await placesWebServices.fetchSuggestions(place, sessionToken);
    return suggestions.map((suggestions) => PlaceSuggestion.fromJson(suggestions)).toList();
  }

  Future<PlaceDetails> fetchPlaceDetails(String placeId, String sessionToken) async{
    final rawData = await placesWebServices.fetchPlaceDetails(placeId, sessionToken);
    final placeDetails = PlaceDetails.fromJson(rawData);
    return placeDetails;
  }

  Future<PlaceDirections> fetchDirections(LatLng origin, LatLng destination) async{
    final rawData = await placesWebServices.fetchDirections(origin, destination);
    final directions =   PlaceDirections.fromJson(rawData);
    return directions;
  }
}