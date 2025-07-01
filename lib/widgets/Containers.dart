import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_adoption/constants/fonts.dart';

Widget CategoryCard(String label, String path) {
  return Container(
    width: 120,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: Color(0xffFA812F),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80, // Set the width of the circular container
          height: 80, // Set the height of the circular container
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the circle
            shape: BoxShape.circle, // Makes the container circular
          ),
          child: Padding(
            padding: const EdgeInsets.all(
                12.0), // Optional padding inside the circle
            child: Image.asset(
              path,
              fit: BoxFit.scaleDown,
              height: 42,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
