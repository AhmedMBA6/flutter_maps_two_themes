class PlaceSuggestion {
  late String placeId;
  late String description;

  PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    final prediction = json['placePrediction'];
    placeId = prediction['placeId'] ?? "";
    description = prediction['text']?['text'] ?? "";
  }
}