import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_layer/repos/map/maps_repo.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final MapsRepository mapsRepository;
  MapsCubit(this.mapsRepository) : super(MapsInitial());

  void emitPlaceSuggestions(String place, String sessionToken) async {
    mapsRepository.fetchPlaceSuggestions(place, sessionToken).then((suggestions) {
      emit(PlaceSuggestionsLoaded(suggestions));
    });
}
}