import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption/controllers/favourite_button_controller.dart';
import 'package:pet_adoption/models/pet.dart';
import 'package:confetti/confetti.dart';
import 'package:pet_adoption/widgets/favourite_button.dart';

class PetDetailsSheet extends StatelessWidget {
  final Pet pet;

  const PetDetailsSheet({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    // Confetti controller
    final ConfettiController _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
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
                          child: FavoriteButton(petId: pet.id), // or pet.id
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Pet image
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            pet.url,
                            height: 200,
                            fit: BoxFit.cover,
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
                      child: ElevatedButton(
                        onPressed: () {
                          _confettiController
                              .play(); // Start confetti animation

                          // Show the popup dialog without dismissing the bottom sheet
                          showDialog(
                            context: context,
                            barrierColor:
                                Colors.transparent, // Keep the sheet visible
                            builder: (context) {
                              return Stack(
                                children: [
                                  // Confetti widget
                                  ConfettiWidget(
                                    numberOfParticles: 10,
                                    confettiController: _confettiController,
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
                                    title: const Text("Congratulations!"),
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
                        child: const Text(
                          'Adopt Me',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
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
