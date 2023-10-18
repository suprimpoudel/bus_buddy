import 'package:bus_buddy_user/features/data_source/route/route_cubit.dart';
import 'package:bus_buddy_user/features/data_source/route/route_state.dart';
import 'package:bus_buddy_user/features/model/route.dart';
import 'package:bus_buddy_user/features/ui/screens/all_route/all_route_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/route_details_tile.dart';
import 'package:bus_buddy_user/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RouteListHomeWidget extends StatefulWidget {
  const RouteListHomeWidget({super.key});

  @override
  State<RouteListHomeWidget> createState() => _RouteListHomeWidgetState();
}

class _RouteListHomeWidgetState extends State<RouteListHomeWidget> {
  final List<RouteModel> _routes = [];

  @override
  void initState() {
    context.read<RouteCubit>().getAllRoutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RouteCubit, RouteState>(listener: (context, state) {
      if (mounted) {
        if (state is RouteListSuccessState) {
          _routes.clear();
          _routes.addAll(state.routeList);
          setState(() {});
        } else if (state is RouteListErrorState) {
          context.handleException(state.error);
        }
      }
    }, builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "All Routes",
                  style: GoogleFonts.lato().copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              if (_routes.isNotEmpty)
                IconButton(
                  onPressed: () {
                    context.push("/${AllRouteScreen.routeName}",
                        extra: _routes);
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
            ],
          ),
          state is RouteListLoadingState
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return RouteDetailsTile(route: _routes[index]);
                  },
                  itemCount: _routes.length > 5 ? 5 : _routes.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
        ],
      );
    });
  }
}
