class PlaceDetails {
  final String placeId;
  final String name;
  final String description;
  final Location location;
  final Viewport viewport;

  PlaceDetails({
    required this.placeId,
    required this.name,
    required this.description,
    required this.location,
    required this.viewport,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      placeId: json['id'] ?? '',
      name: json['displayName']?['text'] ?? '',
      description: json['shortFormattedAddress'] ??
          json['formattedAddress'] ??
          '',
      location: Location.fromJson(json['location'] ?? {}),
      viewport: Viewport.fromJson(json['viewport'] ?? {}),
    );
  }
}


class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }

  @override
  String toString() => '($latitude, $longitude)';
}

class Viewport {
  final LatLngPoint low;
  final LatLngPoint high;

  Viewport({required this.low, required this.high});

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      low: LatLngPoint.fromJson(json['low'] ?? {}),
      high: LatLngPoint.fromJson(json['high'] ?? {}),
    );
  }
}

class LatLngPoint {
  final double latitude;
  final double longitude;

  LatLngPoint({required this.latitude, required this.longitude});

  factory LatLngPoint.fromJson(Map<String, dynamic> json) {
    return LatLngPoint(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
  @override
  String toString() => '($latitude, $longitude)';
}
