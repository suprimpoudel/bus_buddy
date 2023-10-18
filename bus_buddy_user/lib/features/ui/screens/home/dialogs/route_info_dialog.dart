import 'package:bus_buddy_user/features/data_source/route/route_cubit.dart';
import 'package:bus_buddy_user/features/data_source/route/route_state.dart';
import 'package:bus_buddy_user/features/model/route.dart';
import 'package:bus_buddy_user/features/ui/screens/all_stops/all_stops_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/key_value_widget.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/two_widgets_row_expanded.dart';
import 'package:bus_buddy_user/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RouteInfoDialog extends StatefulWidget {
  final int? routeId;
  const RouteInfoDialog({super.key, required this.routeId});

  @override
  State<RouteInfoDialog> createState() => _RouteInfoDialogState();
}

class _RouteInfoDialogState extends State<RouteInfoDialog> {
  @override
  void initState() {
    context.read<RouteCubit>().getRouteInfo(widget.routeId);
    super.initState();
  }

  RouteModel? _model;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return BlocConsumer<RouteCubit, RouteState>(listener: (context, state) {
      if (mounted) {
        if (state is RouteSingleErrorState) {
          context.handleException(state.error);
        } else if (state is RouteSuccessState) {
          _model = state.routeModel;
          setState(() {});
        }
      }
    }, builder: (context, state) {
      return SizedBox(
        height: height * 0.6,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: state is RouteSingleLoadingState
                ? const CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _model?.name ?? "N/A",
                        style: GoogleFonts.lato().copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TwoWidgetsExpandedRow(
                        widgetOne: KeyValueWidget(
                          title: "Starting Destination",
                          iconData: Icons.location_on,
                          value: _model?.startDestination?.name,
                        ),
                        widgetTwo: KeyValueWidget(
                          iconData: Icons.location_on,
                          title: "Ending Destination",
                          value: _model?.endDestination?.name,
                          crossAxisAlignment: CrossAxisAlignment.end,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TwoWidgetsExpandedRow(
                        widgetOne: KeyValueWidget(
                          title: "Total Stops",
                          iconData: Icons.stop_circle,
                          value: (_model?.totalStops ?? 0).toString(),
                          onValueClicked: () {
                            context.push("/${AllStopsScreen.routeName}",
                                extra: _model?.id);
                          },
                        ),
                        widgetTwo: KeyValueWidget(
                          iconData: Icons.person,
                          title: "Total Drivers",
                          value: (_model?.totalDrivers ?? 0).toString(),
                          crossAxisAlignment: CrossAxisAlignment.end,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      KeyValueWidget(
                        iconData: Icons.bus_alert,
                        title: "Total Vehicles",
                        value: (_model?.totalVehicles ?? 0).toString(),
                      )
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
