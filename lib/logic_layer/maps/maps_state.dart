part of 'maps_cubit.dart';

abstract class MapsState {}

class MapsInitial extends MapsState {}
class PlaceSuggestionsLoaded extends MapsState {
  final List<dynamic> suggestions;

  PlaceSuggestionsLoaded(this.suggestions);
}
