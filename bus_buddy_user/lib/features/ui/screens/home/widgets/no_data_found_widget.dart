import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No Data Found",
        style: GoogleFonts.lato().copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
      ),
    );
  }
}
