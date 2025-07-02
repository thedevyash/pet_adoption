import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget CategoryCard(String label, String path) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final cardWidth = screenWidth < 600
          ? 100.0
          : screenWidth < 900
              ? 120.0
              : 140.0;

      final circleSize = cardWidth * 0.7;
      return Container(
        width: cardWidth,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xffFA812F),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  path,
                  fit: BoxFit.cover,
                  height: circleSize * 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    },
  );
}
