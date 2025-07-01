import 'package:get/get.dart';

import '../services/storage_service.dart';

class PetControllerFavourite extends GetxController {
  final favorites = <String>{}.obs;
  final storageService = StorageService();

  @override
  void onInit() {
    super.onInit();
    loadFavoritesFromStorage();
  }

  void toggleFavorite(String petId) {
    if (favorites.contains(petId)) {
      favorites.remove(petId);
    } else {
      favorites.add(petId);
    }
    storageService.saveFavorites(favorites.toList());
  }

  Future<void> loadFavoritesFromStorage() async {
    final saved = await storageService.loadFavorites();
    favorites.addAll(saved);
  }

  bool isFavorite(String petId) {
    return favorites.contains(petId);
  }
}
