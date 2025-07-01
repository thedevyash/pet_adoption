import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favourite_button_controller.dart';
import '../models/pet.dart';
import '../widgets/pet_detail_sheet.dart';

class FavouritePetsScreen extends StatefulWidget {
  final List<Pet> allPets; // Pass the list of all pets from the main screen

  const FavouritePetsScreen({super.key, required this.allPets});

  @override
  State<FavouritePetsScreen> createState() => _FavouritePetsScreenState();
}

class _FavouritePetsScreenState extends State<FavouritePetsScreen> {
  final PetControllerFavourite favController =
      Get.find<PetControllerFavourite>();

  @override
  void initState() {
    super.initState();
    favController
        .loadFavoritesFromStorage(); // Initialize the favorite pets list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (favController.favorites.isEmpty) {
          return const Center(
            child: Text(
              "No favorite pets found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        List<Pet> favoritePets = widget.allPets
            .where((pet) => favController.favorites.contains(pet.id))
            .toList();
        if (favoritePets.isEmpty) {
          return const Center(
            child: Text(
              "No favorite pets found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: favoritePets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final pet = favoritePets[index];
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  enableDrag: true,
                  isScrollControlled: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (_) => PetDetailsSheet(
                    pet: pet,
                    heroTag: 'favorite_pet_${pet.id}', // Pass the Hero tag
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          favController.toggleFavorite(pet.id);
                          // Update the favorite pets list
                        },
                        child: Obx(() {
                          return favController.isFavorite(pet.id)
                              ? const Icon(Icons.favorite_rounded,
                                  color: Colors.red)
                              : Icon(Icons.favorite_border,
                                  color: Colors.grey[700]);
                        }),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Hero(
                          tag: 'favorite_pet_${pet.id}', // Unique Hero tag
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
                    Text(
                      "ID: ${pet.id}",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
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
