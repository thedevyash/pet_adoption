import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption/controllers/favourite_button_controller.dart';
import 'package:pet_adoption/controllers/pet_controller.dart';
import 'package:pet_adoption/screens/favourites.dart';

import 'package:pet_adoption/widgets/Containers.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../repositories/pet_repository.dart';
import '../services/pet_service.dart';
import '../widgets/pet_detail_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PetController getPetsController;
  final PetControllerFavourite favController =
      Get.put(PetControllerFavourite());
  final TextEditingController _searchController = TextEditingController();

  var _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    final petService = PetService();
    final petRepository = PetRepository(petService);

    getPetsController = Get.put(PetController(petRepository));

    // Load initial pets
    getPetsController.loadPets(page: 0, limit: 10);
  }

  Future<void> _refreshPets() async {
    await getPetsController.loadPets(page: 0, limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find your buddy :)"),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildHomeScreen(),
          FavouritePetsScreen(allPets: getPetsController.filteredPetList),
          const Center(
            child: Text(
              "History Screen (To be implemented)",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SalomonBottomBar(
          curve: Curves.linear,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.jumpToPage(index); // Navigate to the selected page
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: Colors.purple,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.favorite_border),
              title: const Text("Likes"),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.history),
              title: const Text("History"),
              selectedColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeScreen() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search by name...",
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (query) {
              getPetsController.searchPets(query);
            },
          ),
          const SizedBox(height: 8),
          const Text("Category"),
          const SizedBox(height: 6),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CategoryCard("Dogs"),
                CategoryCard("Cats"),
                CategoryCard("Birds"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              displacement: 1000,
              strokeWidth: 0,
              onRefresh: _refreshPets,
              child: Obx(() {
                if (getPetsController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pets = getPetsController.filteredPetList;

                if (pets.isEmpty) {
                  return const Center(child: Text("No pets found."));
                }

                return GridView.builder(
                  itemCount: pets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final pet = pets[index];
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
                          builder: (_) => PetDetailsSheet(pet: pet),
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
            ),
          ),
        ],
      ),
    );
  }
}
