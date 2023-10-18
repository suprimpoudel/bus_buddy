import 'package:bus_buddy_user/features/model/nearby_bus_request.dart';
import 'package:bus_buddy_user/features/ui/screens/all_nearby_vehicles/all_nearby_vehicles.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/route_list_home_widget.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/search_route_widget.dart';
import 'package:bus_buddy_user/utils/constants/preference_constants.dart';
import 'package:bus_buddy_user/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeItem extends StatefulWidget {
  const HomeItem({super.key});

  @override
  State<HomeItem> createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: height * 0.3,
                color: Theme.of(context).primaryColorDark,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30.0,
                            child: Icon(
                              FontAwesomeIcons.user,
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          FutureBuilder(
                              future: SharedPreferences.getInstance(),
                              builder: (context, snapshot) {
                                return Text(
                                  "Hello, ${snapshot.data?.getString(firstName) ?? "N/A"}",
                                  style: GoogleFonts.lato().copyWith(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                    left: width * 0.05,
                    right: width * 0.05,
                    top: height * 0.15),
                child: const SearchRouteWidget(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Nearby Vehicles",
                        style: GoogleFonts.lato().copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Geolocator.getCurrentPosition().then((pos) async {
                          await SharedPreferences.getInstance().then((value) {
                            var distance =
                                value.getInt(nearbyLocationRadius) ?? 1000;
                            context.push(
                              "/${AllNearbyVehicles.routeName}",
                              extra: NearbyBusRequest(
                                latitude: pos.latitude,
                                longitude: pos.longitude,
                                distance: distance,
                              ),
                            );
                          });
                        }).catchError((onError) {
                          context.handleException(onError);
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                    ),
                  ],
                ),
                const RouteListHomeWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
