import 'package:bus_buddy_user/features/data_source/route_assessment/route_assessment_cubit.dart';
import 'package:bus_buddy_user/features/data_source/route_assessment/route_assessment_state.dart';
import 'package:bus_buddy_user/features/model/location_update.dart';
import 'package:bus_buddy_user/features/model/route_assessment.dart';
import 'package:bus_buddy_user/features/ui/screens/home/dialogs/route_info_dialog.dart';
import 'package:bus_buddy_user/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowRouteAssessmentInfoBottomModal extends StatefulWidget {
  final int? vehicleId;
  const ShowRouteAssessmentInfoBottomModal(
      {super.key, required this.vehicleId});

  @override
  State<ShowRouteAssessmentInfoBottomModal> createState() =>
      _ShowRouteAssessmentInfoBottomModalState();
}

class _ShowRouteAssessmentInfoBottomModalState
    extends State<ShowRouteAssessmentInfoBottomModal> {
  @override
  void initState() {
    context
        .read<RouteAssessmentCubit>()
        .getRouteAssessmentDetailByVehicleId(widget.vehicleId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RouteAssessment routeAssessment = RouteAssessment();
    return BlocConsumer<RouteAssessmentCubit, RouteAssessmentState>(
        listener: (context, state) {
      if (mounted) {
        if (state is RouteAssessmentSuccessState) {
          routeAssessment = state.routeAssessment;
        } else if (state is RouteAssessmentErrorState) {
          context.handleException(state.error);
        }
      }
    }, builder: (context, state) {
      return SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: state is RouteAssessmentLoadingState
                ? const SizedBox(
                    height: 40, width: 40, child: CircularProgressIndicator())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Route Info: ",
                              style: GoogleFonts.lato().copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (context) => RouteInfoDialog(
                                  routeId: routeAssessment.route?.id));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.route,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child:
                                    Text(routeAssessment.route?.name ?? "N/A"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.bus_alert,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Text(
                                  "Vehicle Number: ${routeAssessment.vehicle?.vehicleNumber ?? "N/A"}"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.bus_alert,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Text(
                                  "Vehicle Model: ${routeAssessment.vehicle?.model ?? "N/A"}"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Text(
                                  "Driver: ${routeAssessment.driver?.firstName ?? "N/A"} ${routeAssessment.driver?.lastName ?? "N/A"}"),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            await Geolocator.getCurrentPosition().then((value) {
                              context
                                  .read<RouteAssessmentCubit>()
                                  .calculateEAT(
                                    LiveLocationUpdate(
                                      latitude: value.latitude,
                                      longitude: value.longitude,
                                      driverId: 1,
                                    ),
                                  )
                                  .then((value) {
                                context.displaySnackbar(
                                    "Estimated arrival time is ${value.toStringAsFixed(2)} minutes");
                              }).catchError((onError) {
                                context.handleException(onError);
                              });
                            }).catchError((onError) {
                              context.handleException(onError);
                            });
                          },
                          child: const Text("Calculate EAT"),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
