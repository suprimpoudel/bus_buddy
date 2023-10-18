import 'dart:convert';

import 'package:bus_buddy_user/features/model/live_location.dart';
import 'package:bus_buddy_user/utils/constants/api_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MarkerLayerWidget extends StatefulWidget {
  const MarkerLayerWidget({super.key});

  @override
  State<MarkerLayerWidget> createState() => _MarkerLayerWidgetState();
}

class _MarkerLayerWidgetState extends State<MarkerLayerWidget> {
  final List<Marker> _marker = [];

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    FirebaseDatabase.instance.ref().child(liveLocation).onValue.listen((event) {
      var drivers = event.snapshot.children;
      _marker.clear();
      setState(() {});
      for (var element in drivers) {
        var keys = element.children.last;
        var liveLocation =
            LiveLocation.fromJson(jsonDecode(jsonEncode(keys.value ?? {})));
        _marker.add(
          Marker(
            height: 12,
            width: 12,
            child: ColoredBox(color: Colors.blue[900]!),
            point: LatLng(
                liveLocation.latitude ?? 0.0, liveLocation.longitude ?? 0.0),
          ),
        );
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
