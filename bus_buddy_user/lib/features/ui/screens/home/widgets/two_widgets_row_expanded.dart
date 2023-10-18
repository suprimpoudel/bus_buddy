import 'package:flutter/material.dart';

class TwoWidgetsExpandedRow extends StatelessWidget {
  final double? gapBetweenWidgets;
  final Widget widgetOne;
  final Widget widgetTwo;
  final int? flexOne;
  final int? flexTwo;
  final CrossAxisAlignment? crossAxisAlignment;
  const TwoWidgetsExpandedRow({
    Key? key,
    this.gapBetweenWidgets,
    required this.widgetOne,
    required this.widgetTwo,
    this.flexOne,
    this.flexTwo,
    this.crossAxisAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        Expanded(flex: flexOne ?? 1, child: widgetOne),
        SizedBox(
          width: gapBetweenWidgets ?? 10.0,
        ),
        Expanded(flex: flexTwo ?? 1, child: widgetTwo),
      ],
    );
  }
}
