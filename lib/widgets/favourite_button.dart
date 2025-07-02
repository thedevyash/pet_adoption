import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:like_button/like_button.dart';
import 'package:pet_adoption/controllers/favourite_button_controller.dart';
import 'package:pet_adoption/models/Pet.dart';

Widget likebutton(PetControllerFavourite favController, Pet pet) {
  return GestureDetector(
    onTap: () {
      favController.toggleFavorite(pet.id);
    },
    child: Obx(() {
      return Container(
        child: LikeButton(
          onTap: (isLiked) async {
            favController.toggleFavorite(pet.id);
            return !isLiked;
          },
          isLiked: favController.isFavorite(pet.id),
          size: 30,
        ),
      );
    }),
  );
}
