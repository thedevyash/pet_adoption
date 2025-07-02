import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:pet_adoption/constants/fonts.dart';
import 'package:pet_adoption/controllers/favourite_button_controller.dart';
import 'package:pet_adoption/controllers/pet_controller.dart';
import 'package:pet_adoption/models/pet.dart';
import 'package:confetti/confetti.dart';
import 'dart:ui';

import 'package:pet_adoption/widgets/Image_view.dart';

class PetDetailsSheet extends StatelessWidget {
  final Pet pet;
  final String heroTag;

  const PetDetailsSheet({super.key, required this.pet, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final ConfettiController _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    final PetController petController = Get.find<PetController>();
    final PetControllerFavourite favController =
        Get.put(PetControllerFavourite());

    return Container(
      child: DraggableScrollableSheet(
        shouldCloseOnMinExtent: true,
        initialChildSize: 1,
        minChildSize: 0.9,
        maxChildSize: 1,
        expand: true,
        builder: (context, scrollController) {
          return Stack(
            children: [
              // Pet image with Hero animation
              Hero(
                tag: heroTag,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to a new screen for zooming
                    Get.to(ImageZoomView(imageUrl: pet.url, heroTag: heroTag));
                  },
                  child: SizedBox(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                      child: Image.network(
                        pet.url,
                        height: MediaQuery.of(context).size.height *
                            0.6, // Increased image size

                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Glass-like overlay for pet name
              Positioned(
                top: 0, // Adjusted position
                left: 0,
                right: 0,
                child: GlassContainer(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  blur: 15,
                  opacity: 0.2,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Pet name
                        Text(
                          pet.breeds[0].name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Like button
                        GestureDetector(
                          onTap: () {
                            favController.toggleFavorite(pet.id);
                          },
                          child: Obx(() {
                            return LikeButton(
                              onTap: (isLiked) async {
                                favController.toggleFavorite(pet.id);
                                return !isLiked;
                              },
                              isLiked: favController.isFavorite(pet.id),
                              size: 30,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Details card at the bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10), // Curved rounded border
                    ),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black26,
                    //     blurRadius: 10,
                    //     offset: Offset(0, -5),
                    //   ),
                    // ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // Pet details
                        Text(
                          "About ${pet.breeds[0].name}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "This is a detailed description of ${pet.breeds[0].name}. "
                          "They are a friendly and loving companion, perfect for families or individuals. "
                          "Make sure to give them lots of love and care!",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Age and Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Age: 4 years",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Price: \$100",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // Adopt Me button
                        Center(
                          child: Obx(() {
                            final isAdopted = petController.isAdopted(pet.id);
                            return ElevatedButton(
                              onPressed: isAdopted
                                  ? null
                                  : () {
                                      petController.toggleAdoption(pet.id);
                                      _confettiController.play();

                                      showDialog(
                                        context: context,
                                        barrierColor: Colors.transparent,
                                        builder: (context) {
                                          return Stack(
                                            children: [
                                              ConfettiWidget(
                                                numberOfParticles: 10,
                                                confettiController:
                                                    _confettiController,
                                                blastDirectionality:
                                                    BlastDirectionality
                                                        .explosive,
                                                shouldLoop: false,
                                                colors: const [
                                                  Colors.red,
                                                  Colors.green,
                                                  Colors.blue,
                                                  Colors.orange,
                                                  Colors.purple,
                                                ],
                                              ),
                                              AlertDialog(
                                                title: Text(
                                                  "Congratulations!",
                                                  style: textStyle.title,
                                                ),
                                                content: Text(
                                                  "You’ve now adopted ${pet.breeds[0].name}!",
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("OK"),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                isAdopted ? 'Already Adopted' : 'Adopt Me',
                                style: textStyle.title,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
