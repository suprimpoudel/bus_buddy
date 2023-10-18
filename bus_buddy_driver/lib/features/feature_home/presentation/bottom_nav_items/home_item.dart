import 'package:bus_buddy_driver/features/feature_dashboard/data_source/dashboard_cubit.dart';
import 'package:bus_buddy_driver/features/feature_dashboard/data_source/dashboard_state.dart';
import 'package:bus_buddy_driver/utils/helper/logger.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeItem extends StatefulWidget {
  const HomeItem({super.key});

  @override
  State<HomeItem> createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> {
  @override
  void initState() {
    context.read<DashboardCubit>().getRouteAssessmentByDriver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  try {
                    FirebaseDatabase.instance.ref().set("Test").then((value) {
                      Logging.log("Successfuly");
                    });
                  } catch (e) {
                    Logging.log(e);
                  }
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: state is DashboardLoadingState
            ? const Center(child: CircularProgressIndicator())
            : state is DashboardSuccessState
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "Hello, ${state.routeAssessment.driver?.firstName} ${state.routeAssessment.driver?.lastName}",
                              style: GoogleFonts.lato().copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                                "You have been assigned the route ${state.routeAssessment.route?.name}"),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      "You don't have any routes assigned",
                    ),
                  ),
      );
    });
  }
}
