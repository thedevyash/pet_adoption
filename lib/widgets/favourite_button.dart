import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption/controllers/favourite_button_controller.dart';

class FavoriteButton extends StatelessWidget {
  final String petId;

  const FavoriteButton({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PetControllerFavourite>();

    return Obx(() {
      final isFav = controller.isFavorite(petId);
      return GestureDetector(
        onTap: () => controller.toggleFavorite(petId),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isFav ? Colors.pink[50] : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.pink : Colors.grey,
          ),
        ),
      );
    });
  }
}
