import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';
import '../repositories/pet_repository.dart';

class PetController extends GetxController {
  final PetRepository _repository;

  PetController(this._repository);

  var petList = <Pet>[].obs;
  var filteredPetList = <Pet>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var adoptedPets = <String>[].obs;

  Future<void> loadPets({required int page, required int limit}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final pets = await _repository.getPets(page: page, limit: limit);
      petList.assignAll(pets);
      filteredPetList.assignAll(pets);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void searchPets(String query) {
    if (query.trim().isEmpty) {
      filteredPetList.assignAll(petList);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredPetList.assignAll(
        petList.where(
          (pet) => pet.breeds.any(
            (breed) => breed.name.toLowerCase().contains(lowerQuery),
          ),
        ),
      );
    }
  }

  void toggleAdoption(String petId) {
    if (adoptedPets.contains(petId)) {
      adoptedPets.remove(petId);
    } else {
      adoptedPets.add(petId);
    }
    saveAdoptionState();
    update();
  }

  bool isAdopted(String petId) {
    return adoptedPets.contains(petId);
  }

  Future<void> saveAdoptionState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('adoptedPets', adoptedPets);
  }

  Future<void> loadAdoptionState() async {
    final prefs = await SharedPreferences.getInstance();
    adoptedPets.value = prefs.getStringList('adoptedPets') ?? [];
  }
}
