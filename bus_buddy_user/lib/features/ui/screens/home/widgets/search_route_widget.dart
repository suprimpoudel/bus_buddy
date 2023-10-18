import 'package:bus_buddy_user/features/data_source/place/place_cubit.dart';
import 'package:bus_buddy_user/features/model/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchRouteWidget extends StatefulWidget {
  const SearchRouteWidget({super.key});

  @override
  State<SearchRouteWidget> createState() => _SearchRouteWidgetState();
}

class _SearchRouteWidgetState extends State<SearchRouteWidget> {
  final TextEditingController _startDestinationController =
      TextEditingController();
  final TextEditingController _endDestinationController =
      TextEditingController();

  Place? _placeOne;
  Place? _placeTwo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search by Place",
              style: GoogleFonts.lato().copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            TypeAheadFormField(
              autoFlipDirection: true,
              textFieldConfiguration: TextFieldConfiguration(
                onTap: () =>
                    _startDestinationController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _startDestinationController.value.text.length,
                ),
                autofocus: false,
                onChanged: (value) {
                  if (_placeOne?.id != null) {
                    _startDestinationController.clear();
                    _placeOne = null;
                    setState(() {});
                  }
                },
                controller: _startDestinationController,
                decoration: const InputDecoration(
                  hintText: "Search for place",
                  border: OutlineInputBorder(),
                  label: Text("Place One"),
                  prefixIcon: Icon(
                    FontAwesomeIcons.locationCrosshairs,
                  ),
                ),
                textInputAction: TextInputAction.search,
              ),
              suggestionsCallback: (pattern) async {
                return await _getPlaceSuggestions(pattern);
              },
              noItemsFoundBuilder: (context) {
                return const SizedBox();
              },
              errorBuilder: (context, object) {
                return const SizedBox();
              },
              itemBuilder: (context, dynamic suggestion) {
                if (suggestion is Place) {
                  return ListTile(
                    title: Text(suggestion.name ?? ""),
                  );
                } else {
                  return const SizedBox();
                }
              },
              onSuggestionSelected: (Place suggestion) async {
                _placeOne = suggestion;
                _startDestinationController.text = suggestion.name ?? "N/A";
                setState(() {});
              },
            ),
            const SizedBox(
              height: 15.0,
            ),
            TypeAheadFormField(
              autoFlipDirection: true,
              textFieldConfiguration: TextFieldConfiguration(
                onTap: () =>
                    _endDestinationController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _endDestinationController.value.text.length,
                ),
                onChanged: (value) {
                  if (_placeTwo?.id != null) {
                    _endDestinationController.clear();
                    _placeTwo = null;
                    setState(() {});
                  }
                },
                autofocus: false,
                controller: _endDestinationController,
                decoration: const InputDecoration(
                  hintText: "Search for place",
                  border: OutlineInputBorder(),
                  label: Text("Place Two"),
                  prefixIcon: Icon(
                    FontAwesomeIcons.locationCrosshairs,
                  ),
                ),
                textInputAction: TextInputAction.search,
              ),
              suggestionsCallback: (pattern) async {
                return await _getPlaceSuggestions(pattern);
              },
              noItemsFoundBuilder: (context) {
                return const SizedBox();
              },
              errorBuilder: (context, object) {
                return const SizedBox();
              },
              itemBuilder: (context, dynamic suggestion) {
                if (suggestion is Place) {
                  return ListTile(
                    title: Text(suggestion.name ?? ""),
                  );
                } else {
                  return const SizedBox();
                }
              },
              onSuggestionSelected: (Place suggestion) async {
                _placeTwo = suggestion;
                _endDestinationController.text = suggestion.name ?? "N/A";
                setState(() {});
              },
            ),
            const SizedBox(
              height: 15.0,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  if (_placeOne?.id == null || _placeTwo?.id == null) {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Error"),
                        content: const Text(
                            "Please select both place in order to search for routes"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text("OK")),
                        ],
                      ),
                    );
                  } else {
                    context.push("/searchedRouteScreen", extra: {
                      'placeOne': (_placeOne?.id ?? -1).toString(),
                      'placeTwo': (_placeTwo?.id ?? -1).toString()
                    });
                  }
                },
                child: const Text("Search"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Place>> _getPlaceSuggestions(String pattern) async {
    var places = await context.read<PlaceCubit>().getAllPlace();
    return places
        .where((element) =>
            element.name?.toLowerCase().contains(pattern.toLowerCase()) == true)
        .toList();
  }
}
