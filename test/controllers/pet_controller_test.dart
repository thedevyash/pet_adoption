import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pet_adoption/controllers/pet_controller.dart';
import 'package:pet_adoption/models/pet.dart';
import 'package:pet_adoption/repositories/pet_repository.dart';

// Mock class for PetRepository
class MockPetRepository extends Mock implements PetRepository {}

void main() {
  late PetController petController;
  late MockPetRepository mockRepository;

  setUp(() {
    mockRepository = MockPetRepository();
    petController = PetController(mockRepository);

    // Initialize SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
  });

  group('PetController Tests', () {
    test('loadPets should fetch and assign pets to petList and filteredPetList',
        () async {
      // Arrange
      final mockPets = [
        Pet(id: '1', url: 'url1', breeds: [], height: 1, width: 1),
        Pet(id: '1', url: 'url1', breeds: [], height: 1, width: 1),
      ];
      when(mockRepository.getPets(page: 0, limit: 10))
          .thenAnswer((_) async => mockPets);

      // Act
      await petController.loadPets(page: 0, limit: 10);

      // Assert
      expect(petController.petList.length, 2);
      expect(petController.filteredPetList.length, 2);
      expect(petController.petList[0].id, '1');
      expect(petController.petList[1].id, '2');
    });

    test('searchPets should filter pets based on query', () {
      // Arrange
      petController.petList.assignAll([
        Pet(id: '1', url: 'url1', breeds: [], height: 1, width: 1),
        Pet(id: '1', url: 'url1', breeds: [], height: 1, width: 1),
      ]);

      // Act
      petController.searchPets('Breed1');

      // Assert
      expect(petController.filteredPetList.length, 1);
      expect(petController.filteredPetList[0].breeds[0].name, 'Breed1');
    });

    test('toggleAdoption should add or remove pet from adoptedPets', () async {
      // Act
      petController.toggleAdoption('1');

      // Assert
      expect(petController.adoptedPets.contains('1'), true);

      // Act
      petController.toggleAdoption('1');

      // Assert
      expect(petController.adoptedPets.contains('1'), false);
    });

    test('isAdopted should return true if pet is adopted', () {
      // Arrange
      petController.adoptedPets.add('1');

      // Act
      final result = petController.isAdopted('1');

      // Assert
      expect(result, true);
    });

    test('saveAdoptionState should persist adoptedPets to SharedPreferences',
        () async {
      // Arrange
      petController.adoptedPets.add('1');

      // Act
      await petController.saveAdoptionState();

      // Assert
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('adoptedPets'), ['1']);
    });

    test('loadAdoptionState should load adoptedPets from SharedPreferences',
        () async {
      // Arrange
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('adoptedPets', ['1', '2']);

      // Act
      await petController.loadAdoptionState();

      // Assert
      expect(petController.adoptedPets.length, 2);
      expect(petController.adoptedPets.contains('1'), true);
      expect(petController.adoptedPets.contains('2'), true);
    });
  });
}
