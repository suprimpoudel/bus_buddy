import 'package:bus_buddy_user/features/data_source/route/route_cubit.dart';
import 'package:bus_buddy_user/features/data_source/route/route_state.dart';
import 'package:bus_buddy_user/features/model/route.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/loading_widget.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/no_data_found_widget.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/route_details_tile.dart';
import 'package:bus_buddy_user/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchedRouteScreen extends StatefulWidget {
  static const String routeName = "searchedRouteScreen";

  final String? placeOneId;
  final String? placeTwoId;
  const SearchedRouteScreen(
      {super.key, required this.placeOneId, required this.placeTwoId});

  @override
  State<SearchedRouteScreen> createState() => _SearchedRouteScreenState();
}

class _SearchedRouteScreenState extends State<SearchedRouteScreen> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    if (widget.placeOneId != null && widget.placeTwoId != null) {
      context
          .read<RouteCubit>()
          .getPlaceBetweenRoutes(widget.placeOneId!, widget.placeTwoId!);
    }
  }

  final List<RouteModel> _routeList = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RouteCubit, RouteState>(listener: (context, state) {
      if (mounted) {
        if (state is RouteErrorState) {
          context.handleException(state.error);
        } else if (state is RouteSearchSuccessState) {
          _routeList.clear();
          _routeList.addAll(state.routeList);
          setState(() {});
        }
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Search Results"),
        ),
        body: state is RouteLoadingState
            ? const LoadingWidget()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: _routeList.isEmpty
                    ? const NoDataFoundWidget()
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          var routeModel = _routeList[index];
                          return RouteDetailsTile(route: routeModel);
                        },
                        itemCount: _routeList.length,
                      ),
              ),
      );
    });
  }
}
