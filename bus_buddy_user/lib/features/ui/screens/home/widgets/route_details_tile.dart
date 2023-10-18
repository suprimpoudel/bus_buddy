import 'package:bus_buddy_user/features/model/route.dart';
import 'package:bus_buddy_user/features/ui/screens/home/dialogs/route_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RouteDetailsTile extends StatelessWidget {
  final RouteModel route;
  const RouteDetailsTile({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          await showDialog(
              context: context,
              builder: (context) => RouteInfoDialog(routeId: route.id));
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListTile(
            leading: const Icon(FontAwesomeIcons.route),
            title: Text(route.name ?? "N/A"),
          ),
        ),
      ),
    );
  }
}
