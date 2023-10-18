import 'dart:convert';

import 'package:bus_buddy_user/features/data_source/location/live_location_cubit.dart';
import 'package:bus_buddy_user/features/model/live_location.dart';
import 'package:bus_buddy_user/features/ui/screens/home/dialogs/show_route_assessment_info_bottom_modal.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/no_data_found_widget.dart';
import 'package:bus_buddy_user/features/ui/screens/shared/location_permission_denied_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart' as p;

import '../../../../../utils/constants/api_constants.dart';

class NearbyBusItem extends StatefulWidget {
  const NearbyBusItem({super.key});

  @override
  State<NearbyBusItem> createState() => _NearbyBusItemState();
}

class _NearbyBusItemState extends State<NearbyBusItem> {
  final MapController _controller = MapController();

  @override
  void initState() {
    _initSetup();
    super.initState();
  }

  Future<void> _initSetup() async {
    await Future.delayed(const Duration(seconds: 1)).then((value) async {
      await p.Permission.location.isGranted.then((value) async {
        if (!value) {
          context
              .pushReplacement("/${LocationPermissionDeniedScreen.routeName}");
        }
      });
    });

    FirebaseDatabase.instance.ref().child(liveLocation).onValue.listen((event) {
      List<Marker> marker = [];
      var drivers = event.snapshot.children;
      for (var element in drivers) {
        var keys = element.children.last;
        var liveLocation =
            LiveLocation.fromJson(jsonDecode(jsonEncode(keys.value ?? {})));
        marker.add(
          Marker(
            child: IconButton(
              onPressed: () async {
                showBottomSheet(
                    context: context,
                    builder: (context) => ShowRouteAssessmentInfoBottomModal(
                          vehicleId: liveLocation.vehicleId,
                        ));
              },
              icon: Icon(
                Icons.bus_alert,
                color: Colors.deepOrange.shade800,
              ),
            ),
            point: LatLng(
                liveLocation.latitude ?? 0.0, liveLocation.longitude ?? 0.0),
          ),
        );
      }
      context.read<LiveLocationCubit>().setMarkers(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Geolocator.isLocationServiceEnabled(),
        builder: (context, locationServiceSnapshot) {
          if (locationServiceSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (locationServiceSnapshot.data == true) {
            return FutureBuilder(
                future: Geolocator.getCurrentPosition(),
                builder: (context, snapshot) {
                  return FlutterMap(
                    mapController: _controller,
                    options: MapOptions(
                      initialCenter: LatLng(
                          snapshot.data?.latitude ?? 27.7014167,
                          snapshot.data?.longitude ?? 85.3133372),
                      initialZoom: 12,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all - InteractiveFlag.rotate,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'dev.fleaflet.flutter_map.example',
                      ),
                      BlocBuilder<LiveLocationCubit, List<Marker>>(
                        builder: (context, state) {
                          return MarkerLayer(
                            markers: state,
                          );
                        },
                      ),
                    ],
                  );
                });
          } else {
            return const NoDataFoundWidget();
          }
        });
  }
}
