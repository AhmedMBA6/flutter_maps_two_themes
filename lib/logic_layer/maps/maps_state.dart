part of 'maps_cubit.dart';

abstract class MapsState {}

class MapsInitial extends MapsState {}

class MapsLoading extends MapsState {}

class MapsLocationLoaded extends MapsState {
  final Position position;
  final bool shouldCenterCamera;

  MapsLocationLoaded(this.position, {this.shouldCenterCamera = false});
}

class MapsError extends MapsState {
  final String message;
  MapsError(this.message);
}

class MapsSuggestionsLoaded extends MapsState {
  final List<PlaceSuggestion> suggestions;
  MapsSuggestionsLoaded(this.suggestions);
}

class MapsMessage extends MapsState {
  final String message;
  MapsMessage(this.message);
}

class MapMarkersUpdated extends MapsState {
  final Set<Marker> markers;
  MapMarkersUpdated(this.markers);
}


class PlaceSuggestionsLoaded extends MapsState {
  final List<dynamic> suggestions;

  PlaceSuggestionsLoaded(this.suggestions);
}

class PlaceSuggestionsCleared extends MapsState {}

class PlaceDetailsLoaded extends MapsState {
  final PlaceDetails placeDetails;

  PlaceDetailsLoaded(this.placeDetails);
}
