import 'package:bus_buddy_driver/features/data_source/location_tracking/location_tracking_cubit.dart';
import 'package:bus_buddy_driver/features/data_source/location_tracking/location_tracking_service_cubit.dart';
import 'package:bus_buddy_driver/features/data_source/location_tracking/tracking_cubit.dart';
import 'package:bus_buddy_driver/features/presentation/location_permission_denied_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart' as p;

class BusTrackingItem extends StatefulWidget {
  const BusTrackingItem({super.key});

  @override
  State<BusTrackingItem> createState() => _BusTrackingItemState();
}

class _BusTrackingItemState extends State<BusTrackingItem> {
  final _mapController = MapController();

  @override
  void initState() {
    _initSetup();
    super.initState();
  }

  Future<void> _initSetup() async {
    if (mounted) {
      await Future.delayed(const Duration(seconds: 1)).then((value) async {
        if (mounted) {
          await p.Permission.location.isGranted.then((value) async {
            if (mounted) {
              if (!value) {
                context.pushReplacement(
                    "/${LocationPermissionDeniedScreen.route}");
              } else {
                if (mounted) {
                  if (context.read<LocationTrackingServiceCubit>().state) {
                    Geolocator.isLocationServiceEnabled().then((value) {
                      if (value) {
                        Geolocator.getPositionStream().listen((event) {
                          if (mounted) {
                            _mapController.move(
                                LatLng(event.latitude, event.longitude), 10.0);
                            context.read<TrackingCubit>().emit(Marker(
                                  builder: (context) => Icon(
                                    Icons.bus_alert,
                                    color: Colors.deepOrange.shade800,
                                  ),
                                  point: LatLng(event.latitude ?? 0.0,
                                      event.longitude ?? 0.0),
                                ));
                            if (context
                                .read<LocationTrackingServiceCubit>()
                                .state) {
                              context
                                  .read<LocationTrackingCubit>()
                                  .updateDriverLocation(event);
                            }
                          }
                        });
                      }
                    });
                  }
                }
              }
            }
          });
        }
      });
    }
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
            return BlocBuilder<LocationTrackingServiceCubit, bool>(
                builder: (context, state) {
              return !state
                  ? Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<LocationTrackingServiceCubit>()
                              .updateService(true);
                        },
                        child: const Text("Start"),
                      ),
                    )
                  : Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'dev.fleaflet.flutter_map.example',
                            ),
                            BlocBuilder<TrackingCubit, Marker?>(
                              builder: (context, state) {
                                if (state != null) {
                                  return MarkerLayer(
                                    markers: [state],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<LocationTrackingServiceCubit>()
                                  .updateService(false);
                            },
                            child: const Text("Stop"),
                          ),
                        )
                      ],
                    );
            });
          } else {
            return StreamBuilder(
              stream: Geolocator.getServiceStatusStream(),
              builder: (context, stream) {
                if (stream.data == ServiceStatus.enabled) {
                  return const Text("Location Granted");
                } else {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Geolocator.openLocationSettings();
                      },
                      child: const Text("Enable GPS"),
                    ),
                  );
                }
              },
            );
          }
        });
  }
}
