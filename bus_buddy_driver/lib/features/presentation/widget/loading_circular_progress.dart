import 'package:flutter/material.dart';

class LoadingCircularProgress extends StatelessWidget {
  final String? progressMessage;
  final double? opacity;
  const LoadingCircularProgress({Key? key, this.progressMessage, this.opacity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(opacity ?? 0.5),
            height: double.infinity,
            width: double.infinity,
          ),
          const Center(
            child: CircularProgressIndicator(
                // color: Theme.of(context).primaryColor,
                ),
          ),
        ],
      ),
    );
  }
}
