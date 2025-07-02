import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pet_adoption/models/Pet.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_adoption/controllers/pet_controller.dart';
import 'package:pet_adoption/controllers/theme_controller.dart';
import 'package:pet_adoption/screens/home.dart';
import 'package:pet_adoption/repositories/pet_repository.dart';
import 'package:pet_adoption/services/pet_service.dart';

// Mock classes
class MockPetRepository extends Mock implements PetRepository {}

void main() {
  late MockPetRepository mockRepository;
  late PetController petController;

  setUp(() {
    mockRepository = MockPetRepository();
    petController = Get.put(PetController(mockRepository));
    Get.put(ThemeController());
  });

  testWidgets('HomeScreen displays pets and handles navigation',
      (WidgetTester tester) async {
    // Arrange
    final mockPets = [
      Pet(
          height: 1,
          width: 1,
          id: '1',
          url: 'https://example.com/dog1.jpg',
          breeds: []),
      Pet(
          height: 1,
          width: 1,
          id: '1',
          url: 'https://example.com/dog1.jpg',
          breeds: []),
    ];
    when(mockRepository.getPets(page: 0, limit: 10))
        .thenAnswer((_) async => mockPets);

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: HomeScreen(),
      ),
    );

    // Wait for pets to load
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Find your buddy :)'), findsOneWidget); // AppBar title
    expect(find.byType(GridView), findsOneWidget); // Pet grid
    expect(find.text('Dog'), findsOneWidget); // Pet name
    expect(find.text('Cat'), findsOneWidget); // Pet name

    // Test navigation to Favourites
    await tester.tap(find.byIcon(Icons.favorite_rounded));
    await tester.pumpAndSettle();
    expect(
        find.text('Favourite Pets'), findsOneWidget); // Favourites screen title

    // Test navigation to Adopted Pets
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();
    expect(
        find.text('Adopted Pets'), findsOneWidget); // Adopted Pets screen title
  });

  testWidgets('HomeScreen handles theme toggle', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: HomeScreen(),
      ),
    );

    // Assert initial theme
    final ThemeController themeController = Get.find<ThemeController>();
    expect(themeController.themeMode.value, false);

    // Toggle theme
    await tester.tap(find.byIcon(Icons.brightness_6));
    await tester.pumpAndSettle();

    // Assert theme change
    expect(themeController.themeMode.value, true);
  });

  testWidgets('HomeScreen displays loading indicator while fetching pets',
      (WidgetTester tester) async {
    // Arrange
    when(mockRepository.getPets(page: 0, limit: 10)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return [];
    });

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: HomeScreen(),
      ),
    );

    // Assert loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for pets to load
    await tester.pumpAndSettle();

    // Assert no pets found
    expect(find.text('Uh-oh no pets found !'), findsOneWidget);
  });
}
