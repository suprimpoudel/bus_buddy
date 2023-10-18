import 'package:bus_buddy_user/features/model/route.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/no_data_found_widget.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/route_details_tile.dart';
import 'package:flutter/material.dart';

class AllRouteScreen extends StatelessWidget {
  final List<RouteModel> routes;
  static const String routeName = "allRouteScreen";

  const AllRouteScreen({super.key, required this.routes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Routes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: routes.isEmpty
            ? const NoDataFoundWidget()
            : ListView.builder(
                itemBuilder: (context, index) {
                  var routeModel = routes[index];
                  return RouteDetailsTile(route: routeModel);
                },
                itemCount: routes.length,
              ),
      ),
    );
  }
}
