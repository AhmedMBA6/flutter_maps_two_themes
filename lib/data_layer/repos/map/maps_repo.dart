import 'package:flutter_login_two_themes/data_layer/models/map/place_details.dart';
import 'package:flutter_login_two_themes/data_layer/models/map/place_suggestion.dart';

import '../../webservices/places_web_services.dart';

class MapsRepository {
  final PlacesWebServices placesWebServices;

  MapsRepository(this.placesWebServices);


  Future<List<dynamic>> fetchPlaceSuggestions(String place, String sessionToken) async{
    final suggestions = await placesWebServices.fetchSuggestions(place, sessionToken);
    return suggestions.map((suggestions) => PlaceSuggestion.fromJson(suggestions)).toList();
  }

  Future<PlaceDetails> fetchPlaceDetails(String placeId, String sessionToken) async{
    final rawData = await placesWebServices.fetchPlaceDetails(placeId, sessionToken);
    final placeDetails = PlaceDetails.fromJson(rawData);
    return placeDetails;
  }
}