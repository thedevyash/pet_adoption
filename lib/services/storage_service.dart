import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveFavorites(List<String> petIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', petIds);
  }

  Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }

  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorites');
  }
}
