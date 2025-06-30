import 'package:flutter/material.dart';
import 'package:pet_adoption/models/pet.dart';
import 'package:pet_adoption/widgets/Containers.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../widgets/pet_detail_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> dummyPets = const [
    {
      'name': 'Charlie',
      'image': 'https://cdn2.thecatapi.com/images/MTY3ODIyMQ.jpg',
      'distance': 1.2,
      'color': Color(0xFFD6C8F1),
    },
    {
      'name': 'Brunno',
      'image':
          'https://images.dog.ceo/breeds/bulldog-french/n02108915_12791.jpg',
      'distance': 1.2,
      'color': Color(0xFFF7D3D0),
    },
    {
      'name': 'Ozzy',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/3/32/Lorikeet.jpg',
      'distance': 1.2,
      'color': Color(0xFFC7EABF),
    },
    {
      'name': 'Brook',
      'image': 'https://cdn2.thecatapi.com/images/MTY3ODIyMQ.jpg',
      'distance': 1.2,
      'color': Color(0xFFBFDCE9),
    },
    {
      'name': 'Gracy',
      'image': 'https://images.dog.ceo/breeds/labrador/n02099712_3330.jpg',
      'distance': 1.2,
      'color': Color(0xFFF7DAC8),
    },
    {
      'name': 'Brook',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/7/70/Cute_white_rabbit.jpg',
      'distance': 1.2,
      'color': Color(0xFFBFDCE9),
    },
  ];

  final Pet dummyPet = Pet(
      id: '1',
      name: 'Charlie',
      imageUrl:
          'https://cdn.shopify.com/s/files/1/0086/0795/7054/files/Labrador.jpg?v=1645179151',
      breed: 'French Bulldog',
      age: '2 years',
      distance: 1.2,
      description:
          'Charlie is a friendly and playful dog who loves to go for walks and cuddle.',
      price: "1200");

  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Find your buddy :)"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SearchBar(
                elevation: WidgetStatePropertyAll(0),
                hintText: "Search here...",
                leading: Icon(Icons.search_off_rounded),
              ),
              Text("Category"),
              SizedBox(
                height: 6,
              ),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryCard("Dogs"),
                    CategoryCard("Cats"),
                    CategoryCard("Birds")
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: dummyPets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final pet = dummyPets[index];
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          enableDrag: true,
                          context: context,
                          // showDragHandle: true,
                          isScrollControlled:
                              true, // so it can take full screen height
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (context) => PetDetailsSheet(pet: dummyPet),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: pet['color'],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.grey[700],
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  pet['image'],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pet['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${pet['distance']} km away',
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
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: Colors.purple,
            ),

            /// details
            SalomonBottomBarItem(
              icon: Icon(Icons.favorite_border),
              title: Text("Likes"),
              selectedColor: Colors.pink,
            ),

            /// history
            SalomonBottomBarItem(
              icon: Icon(Icons.search),
              title: Text("Search"),
              selectedColor: Colors.orange,
            ),

            SalomonBottomBarItem(
              icon: Icon(Icons.search),
              title: Text("Search"),
              selectedColor: Colors.orange,
            ),
          ],
        ));
  }
}
