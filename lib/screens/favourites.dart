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
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (favController.favorites.isEmpty) {
            return const Center(
              child: Text(
                "No favorite pets found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Filter favorite pets
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
            itemCount: favoritePets.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final pet = favoritePets[index];

              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    useSafeArea: true,
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
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              pet.breeds[0].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              favController.toggleFavorite(pet.id);
                            },
                            child: Obx(() {
                              return Icon(
                                favController.isFavorite(pet.id)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: favController.isFavorite(pet.id)
                                    ? Colors.red
                                    : Colors.grey,
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
