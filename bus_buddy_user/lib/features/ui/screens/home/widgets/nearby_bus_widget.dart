import 'package:bus_buddy_user/utils/constants/preference_constants.dart';
import 'package:bus_buddy_user/utils/helper/logger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NearbyBusRadiusWidget extends StatefulWidget {
  const NearbyBusRadiusWidget({super.key});

  @override
  State<NearbyBusRadiusWidget> createState() => _NearbyBusRadiusWidgetState();
}

class _NearbyBusRadiusWidgetState extends State<NearbyBusRadiusWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          return ListTile(
            leading: const Icon(Icons.radar),
            subtitle: Text(
                "${snapshot.data?.getInt(nearbyLocationRadius) ?? "1000"} meter"),
            title: const Text("Nearby Bus Radius"),
            onTap: () async {
              return showDialog(
                context: context,
                builder: (context) => SliderRadiusWidget(
                  radius: snapshot.data?.getInt(nearbyLocationRadius) ?? 1000,
                  onSet: () {
                    setState(() {});
                  },
                ),
              ).then((value) {
                if (value == bool && value) {
                  setState(() {});
                }
              });
            },
          );
        });
  }
}

class SliderRadiusWidget extends StatefulWidget {
  final int radius;
  final Function() onSet;
  const SliderRadiusWidget(
      {super.key, required this.radius, required this.onSet});

  @override
  State<SliderRadiusWidget> createState() => _SliderRadiusWidgetState();
}

class _SliderRadiusWidgetState extends State<SliderRadiusWidget> {
  SharedPreferences? _sharedPrefs;
  var _value = 1000.0;

  @override
  void initState() {
    _value = widget.radius.toDouble();
    _initSetup();
    super.initState();
  }

  Future<void> _initSetup() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    Logging.log("Radius is ${widget.radius}");
    return AlertDialog(
      title: const Text("Set Radius"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text("100"),
              Slider(
                min: 100.0,
                max: 2000.0,
                value: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
              const Text("2000"),
            ],
          ),
          Text("${_value.round()} Meters"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await _sharedPrefs
                ?.setInt(nearbyLocationRadius, _value.round())
                .then((value) {
              widget.onSet();
              Navigator.pop(context);
            });
          },
          child: const Text(
            "Ok",
          ),
        ),
      ],
    );
  }
}
