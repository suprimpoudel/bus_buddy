import 'package:bus_buddy_user/features/data_source/nearby_bus/nearby_bus_cubit.dart';
import 'package:bus_buddy_user/features/data_source/nearby_bus/nearby_bus_state.dart';
import 'package:bus_buddy_user/features/model/nearby_bus_location.dart';
import 'package:bus_buddy_user/features/model/nearby_bus_request.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/loading_widget.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/no_data_found_widget.dart';
import 'package:bus_buddy_user/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllNearbyVehicles extends StatefulWidget {
  static const String routeName = "allNearbyVehicles";
  final NearbyBusRequest nearbyBusRequest;
  const AllNearbyVehicles({super.key, required this.nearbyBusRequest});

  @override
  State<AllNearbyVehicles> createState() => _AllNearbyVehiclesState();
}

class _AllNearbyVehiclesState extends State<AllNearbyVehicles> {
  final List<NearbyBusLocation> _nearbyBusLocation = [];

  @override
  void initState() {
    context.read<NearbyBusCubit>().getNearbyBus(widget.nearbyBusRequest);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NearbyBusCubit, NearbyBusLocationState>(
        listener: (context, state) {
      if (mounted) {
        if (state is NearbyBusLocationErrorState) {
          context.handleException(state.error);
        } else if (state is NearbyBusLocationListState) {
          _nearbyBusLocation.clear();
          _nearbyBusLocation.addAll(state.nearbyBusLocations);
          setState(() {});
        }
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("All Nearby Bus"),
        ),
        body: state is NearbyBusLocationLoadingState
            ? const LoadingWidget()
            : _nearbyBusLocation.isEmpty
                ? const NoDataFoundWidget()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      var nearbyBus = _nearbyBusLocation[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.bus_alert),
                          title: Text(nearbyBus.vehicle?.model ?? "N/A"),
                          subtitle:
                              Text(nearbyBus.vehicle?.vehicleNumber ?? "N/A"),
                          trailing: Text(
                              "Distance ${(nearbyBus.distance ?? 0).toStringAsFixed(2)} meters"),
                        ),
                      );
                    },
                    itemCount: _nearbyBusLocation.length,
                  ),
      );
    });
  }
}
