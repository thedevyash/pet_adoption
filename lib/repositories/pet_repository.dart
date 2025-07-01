import '../models/pet.dart';
import '../services/pet_service.dart';

class PetRepository {
  final PetService _service;

  PetRepository(this._service);

  Future<List<Pet>> getPets({
    required int page,
    required int limit,
  }) async {
    final data = await _service.fetchPets(page: page, limit: limit);

    return data;
  }
}
