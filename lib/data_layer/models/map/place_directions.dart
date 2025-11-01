import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

class PlaceDirections {
  late List<List<num>> polylinePoints;
  late int distance;
  late String duration;

  PlaceDirections(
      {required this.polylinePoints,
      required this.distance,
      required this.duration});

  factory PlaceDirections.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json["routes"][0]);

    final distance = data["distanceMeters"];
    final duration = data["duration"];

    return PlaceDirections(
        polylinePoints: decodePolyline(data['polyline']["encodedPolyline"]),
        distance: distance,
        duration: duration);
  }
}
