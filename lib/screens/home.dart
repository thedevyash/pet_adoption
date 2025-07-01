import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:pet_adoption/constants/fonts.dart';
import 'package:pet_adoption/controllers/favourite_button_controller.dart';
import 'package:pet_adoption/controllers/pet_controller.dart';
import 'package:pet_adoption/controllers/theme_controller.dart';
import 'package:pet_adoption/screens/favourites.dart';

import 'package:pet_adoption/widgets/Containers.dart';

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
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: textStyle.title,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              final controller = Get.find<ThemeController>();
              controller.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh), // Add a refresh icon
            onPressed: () {
              _refreshPets(); // Re-hit the API to restore the original results
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildHomeScreen(screenWidth, screenHeight),
          FavouritePetsScreen(allPets: getPetsController.filteredPetList),
          const Center(
            child: Text(
              "History Screen (To be implemented)",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CrystalNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: const Color(0xffFA812F),
          unselectedItemColor: Colors.blueGrey,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.jumpToPage(index);
          },
          items: [
            CrystalNavigationBarItem(
              icon: Icons.home_rounded,
            ),
            CrystalNavigationBarItem(
              icon: Icons.favorite_rounded,
            ),
            CrystalNavigationBarItem(
              icon: Icons.history,
            ),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return "Find your buddy :)"; // Home screen title
      case 1:
        return "Favourite Pets"; // Favourites screen title
      case 2:
        return "History"; // History screen title
      default:
        return "Pet Adoption";
    }
  }

  Widget _buildHomeScreen(double screenWidth, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintStyle: GoogleFonts.poppins(),
              hintText: "Search by name...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1.0),
              ),
            ),
            onChanged: (query) {
              getPetsController.searchPets(query);
            },
          ),
          const SizedBox(height: 8),

          // Categories
          SizedBox(
            height: screenHeight * 0.15, // Adjust height based on screen size
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () {
                    getPetsController.searchPets("Dogs");
                  },
                  child: CategoryCard("Dogs", "assets/dog.png"),
                ),
                GestureDetector(
                  onTap: () {
                    getPetsController.searchPets("Cats");
                  },
                  child: CategoryCard("Cats", "assets/cat.png"),
                ),
                GestureDetector(
                  onTap: () {
                    getPetsController.searchPets("Birds");
                  },
                  child: CategoryCard("Birds", "assets/bird.png"),
                ),
                GestureDetector(
                  onTap: () {
                    getPetsController.searchPets("Fish");
                  },
                  child: CategoryCard("Fish", "assets/fish.png"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Pet Grid
          Expanded(
            child: RefreshIndicator(
              edgeOffset: 1000,
              onRefresh: _refreshPets,
              child: Obx(() {
                if (getPetsController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pets = getPetsController
                    .filteredPetList; // Observe the filtered list reactively
                return GridView.builder(
                  itemCount: pets.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth < 600
                        ? 2
                        : 3, // Adjust columns based on screen width
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    final color = Theme.of(context).cardColor;

                    // Wrap only the part that depends on `isAdopted` in Obx
                    return Obx(() {
                      final isAdopted = getPetsController
                          .isAdopted(pet.id); // Check adoption state reactively
                      return GestureDetector(
                        onTap: () {
                          if (!isAdopted) {
                            showModalBottomSheet(
                              enableDrag: true,
                              isScrollControlled: true,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (_) => PetDetailsSheet(
                                pet: pet,
                                heroTag:
                                    'pet_${pet.id}', // Pass the Hero tag to the details screen
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isAdopted
                                ? Colors.grey[300]
                                : color, // Grey out if adopted
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Hero(
                                    tag:
                                        'pet_${pet.id}', // Unique Hero tag for each pet
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          pet.url.isNotEmpty ? pet.url : '',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                        ),
                                        if (isAdopted)
                                          Container(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "Already Adopted",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    pet.breeds[0].name.length > 10
                                        ? pet.breeds[0].name.substring(0, 8)
                                        : pet.breeds[0].name,
                                    style: textStyle.cardLabel,
                                  ),
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
                                        isLiked:
                                            favController.isFavorite(pet.id),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
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
