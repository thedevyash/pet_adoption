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
import 'package:pet_adoption/screens/history.dart';

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
    getPetsController.loadPets(page: 0, limit: 10);
  }

  Future<void> _refreshPets() async {
    await getPetsController.loadPets(page: 0, limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
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
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _refreshPets();
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
            AdoptedPetsScreen(
              allPets: getPetsController.filteredPetList,
            )
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
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return "Find your buddy :)";
      case 1:
        return "Favourite Pets";
      case 2:
        return "Adopted Pets";
      default:
        return "Pet Adoption";
    }
  }

  Widget _buildHomeScreen(double screenWidth, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
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
          SizedBox(
            height: screenHeight * 0.15,
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
          Expanded(
            child: RefreshIndicator(
              edgeOffset: 1000,
              onRefresh: _refreshPets,
              child: Obx(() {
                if (getPetsController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pets = getPetsController.filteredPetList;

                if (pets.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          height: 35,
                          image: AssetImage("assets/noresult.png"),
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text("Uh-oh no pets found !")
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  itemCount: pets.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth < 600 ? 2 : 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final pet = pets[index];

                    return Obx(() {
                      final isAdopted = getPetsController.isAdopted(pet.id);
                      return GestureDetector(
                        onTap: () {
                          if (!isAdopted) {
                            showModalBottomSheet(
                              useSafeArea: true,
                              enableDrag: true,
                              isScrollControlled: true,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (_) => PetDetailsSheet(
                                pet: pet,
                                heroTag: 'pet_${pet.id}',
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isAdopted
                                ? Colors.grey[300]
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Hero(
                                    tag: 'pet_${pet.id}',
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
