import 'package:bus_buddy_user/features/data_source/stop/stop_cubit.dart';
import 'package:bus_buddy_user/features/data_source/stop/stop_state.dart';
import 'package:bus_buddy_user/features/model/stop.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/loading_widget.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/no_data_found_widget.dart';
import 'package:bus_buddy_user/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllStopsScreen extends StatefulWidget {
  static const String routeName = "stops";
  final int? routeId;
  const AllStopsScreen({super.key, this.routeId});

  @override
  State<AllStopsScreen> createState() => _AllStopsScreenState();
}

class _AllStopsScreenState extends State<AllStopsScreen> {
  final List<Stop> _stops = [];

  @override
  void initState() {
    context.read<StopCubit>().getAllStopBasedOnRouteId(widget.routeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StopCubit, StopState>(listener: (context, state) {
      if (mounted) {
        if (state is StopErrorState) {
          context.handleException(state.error);
        } else if (state is StopListState) {
          _stops.clear();
          _stops.addAll(state.stops);
          _stops.sort((a, b) => a.orderNo?.compareTo(b.orderNo ?? -1) ?? -1);
          setState(() {});
        }
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("All Stops"),
        ),
        body: state is StopLoadingState
            ? const LoadingWidget()
            : _stops.isEmpty
                ? const NoDataFoundWidget()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      var stop = _stops[index];
                      return Card(
                        child: ListTile(
                          title: Text(stop.place?.name ?? "N/A"),
                          subtitle: Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Flexible(
                                child: Text(
                                  "${stop.place?.latitude}, ${stop.place?.longitude}",
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          trailing:
                              Text("Stop Time: ${stop.stopTime ?? 0} mins"),
                        ),
                      );
                    },
                    itemCount: _stops.length,
                  ),
      );
    });
  }
}
