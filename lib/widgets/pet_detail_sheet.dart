import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:pet_adoption/controllers/favourite_button_controller.dart';
import 'package:pet_adoption/controllers/pet_controller.dart';
import 'package:pet_adoption/models/pet.dart';
import 'package:confetti/confetti.dart';

class PetDetailsSheet extends StatelessWidget {
  final Pet pet;
  final String heroTag; // Add a heroTag parameter to match the Hero animation

  const PetDetailsSheet({super.key, required this.pet, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    // Confetti controller
    final ConfettiController _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    final PetController petController = Get.find<PetController>();
    final PetControllerFavourite favController =
        Get.put(PetControllerFavourite());
    return DraggableScrollableSheet(
      shouldCloseOnMinExtent: true,
      initialChildSize: 1,
      minChildSize: 0.9,
      maxChildSize: 1,
      expand: true,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Pet name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pet.breeds[0].name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
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
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Pet image with Hero animation
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: InteractiveViewer(
                                  panEnabled: true, // Enable panning
                                  boundaryMargin: const EdgeInsets.all(20),
                                  minScale: 0.5, // Minimum zoom scale
                                  maxScale: 4.0, // Maximum zoom scale
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      pet.url,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Hero(
                          tag: heroTag, // Use the same Hero tag as in the grid
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              pet.url,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pet details
                    Text(
                      'Age: 4',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price: \$100',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),

                    const SizedBox(height: 16),

                    // Adopt Me button
                    Center(
                      child: Obx(() {
                        final isAdopted = petController.isAdopted(pet.id);
                        return ElevatedButton(
                          onPressed: isAdopted
                              ? null // Disable button if already adopted
                              : () {
                                  petController.toggleAdoption(pet.id);

                                  // Mark as adopted
                                  _confettiController
                                      .play(); // Start confetti animation

                                  // Show the popup dialog without dismissing the bottom sheet
                                  showDialog(
                                    context: context,
                                    barrierColor: Colors
                                        .transparent, // Keep the sheet visible
                                    builder: (context) {
                                      return Stack(
                                        children: [
                                          // Confetti widget
                                          ConfettiWidget(
                                            numberOfParticles: 10,
                                            confettiController:
                                                _confettiController,
                                            blastDirectionality:
                                                BlastDirectionality.explosive,
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
                                            title:
                                                const Text("Congratulations!"),
                                            content: Text(
                                                "You’ve now adopted ${pet.breeds[0].name}!"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            isAdopted ? 'Already Adopted' : 'Adopt Me',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
