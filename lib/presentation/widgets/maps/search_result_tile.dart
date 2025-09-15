import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_two_themes/data_layer/models/map/place_suggestion.dart';
import 'package:flutter_login_two_themes/logic_layer/maps/maps_cubit.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapsCubit, MapsState>(builder: (context, state) {
      if (state is PlaceSuggestionsLoaded) {
        final suggestions = state.suggestions;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: suggestions.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return PlaceItem(
              suggestion: suggestions[index],
            );
          },
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}

class PlaceItem extends StatelessWidget {
  final PlaceSuggestion suggestion;
  const PlaceItem({
    super.key,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    var subTitle = suggestion.description
        .replaceAll(suggestion.description.split(',')[0], '');
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(0.1)),
                child:
                    Icon(Icons.place, color: Theme.of(context).primaryColor)),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${suggestion.description.split(',')[0]}\n',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  TextSpan(
                    text: subTitle.substring(2),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
