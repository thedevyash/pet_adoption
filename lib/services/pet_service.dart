import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pet_adoption/constants/constant.dart';
import '../models/pet.dart';

class PetService {
  // Replace with your actual base URL

  Future<List<Pet>> fetchPets({
    required int page,
    required int limit,
  }) async {
    final url = Uri.parse(
        '${Constants.baseUrl}v1/images/search?size=med&mime_types=jpg&format=json&has_breeds=true&order=RANDOM&page=${page}&limit=${limit}');
    print("req sent");
    final response = await http.get(url, headers: {
      "x-api-key": Constants.apiKey,
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      // print(data.map((json) => Pet.fromJson(json)).toList());
      return data.map((json) => Pet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pets (Status ${response.statusCode})');
    }
  }
}
