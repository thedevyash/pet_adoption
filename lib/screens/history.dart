import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption/constants/fonts.dart';
import '../controllers/pet_controller.dart';
import '../models/pet.dart';
import '../widgets/pet_detail_sheet.dart';

class AdoptedPetsScreen extends StatefulWidget {
  final List<Pet> allPets; // Pass the list of all pets from the main screen

  const AdoptedPetsScreen({super.key, required this.allPets});

  @override
  State<AdoptedPetsScreen> createState() => _AdoptedPetsScreenState();
}

class _AdoptedPetsScreenState extends State<AdoptedPetsScreen> {
  final PetController petController = Get.find<PetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (petController.adoptedPets.isEmpty) {
          return const Center(
            child: Text(
              "No adopted pets found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Filter adopted pets
        List<Pet> adoptedPets = widget.allPets
            .where((pet) => petController.adoptedPets.contains(pet.id))
            .toList();

        if (adoptedPets.isEmpty) {
          return const Center(
            child: Text(
              "No adopted pets found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Get screen width
        final screenWidth = MediaQuery.of(context).size.width;

        // Determine the number of columns based on screen width
        final crossAxisCount = screenWidth < 600
            ? 2 // Mobile: 2 columns
            : screenWidth < 900
                ? 3 // Tablet: 3 columns
                : 4; // Desktop: 4 columns

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: adoptedPets.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final pet = adoptedPets[index];
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  enableDrag: true,
                  isScrollControlled: true,
                  useSafeArea: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (_) => PetDetailsSheet(
                    pet: pet,
                    heroTag: 'adopted_pet_${pet.id}', // Pass the Hero tag
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Hero(
                          tag: 'adopted_pet_${pet.id}', // Unique Hero tag
                          child: Image.network(
                            pet.url.isNotEmpty ? pet.url : '',
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
                    const SizedBox(height: 8),
                    Text(
                      pet.breeds[0].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Adopted",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
