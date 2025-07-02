// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pet_adoption/models/pet.dart';
// import 'package:pet_adoption/widgets/pet_detail_sheet.dart';

// class PetGrid extends StatelessWidget {
//   final List<Pet> pets;
//   final RxBool isLoading;
//   final Future<void> Function() onRefresh;
//   final bool Function(String petId) isAdopted;
//   final void Function(String petId) toggleFavorite;

//   const PetGrid({
//     super.key,
//     required this.pets,
//     required this.isLoading,
//     required this.onRefresh,
//     required this.isAdopted,
//     required this.toggleFavorite,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return RefreshIndicator(
//       onRefresh: onRefresh,
//       child: Obx(() {
//         if (isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (pets.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Image(
//                   height: 35,
//                   image: AssetImage("assets/noresult.png"),
//                   color: Colors.grey,
//                 ),
//                 SizedBox(height: 8),
//                 Text("Uh-oh no pets found !"),
//               ],
//             ),
//           );
//         }

//         return GridView.builder(
//           itemCount: pets.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: screenWidth < 600
//                 ? 2
//                 : 3, // Adjust columns based on screen width
//             mainAxisSpacing: 8,
//             crossAxisSpacing: 8,
//             childAspectRatio: 0.8,
//           ),
//           itemBuilder: (context, index) {
//             final pet = pets[index];

//             return GestureDetector(
//               onTap: () {
//                 if (!isAdopted(pet.id)) {
//                   showModalBottomSheet(
//                     backgroundColor: Theme.of(context).cardColor,
//                     useSafeArea: true,
//                     enableDrag: true,
//                     isScrollControlled: true,
//                     context: context,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(16)),
//                     ),
//                     builder: (_) => PetDetailsSheet(
//                       pet: pet,
//                       heroTag:
//                           'pet_${pet.id}', // Pass the Hero tag to the details screen
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: isAdopted(pet.id)
//                       ? Colors.grey[300]
//                       : Theme.of(context).cardColor, // Grey out if adopted
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 padding: const EdgeInsets.all(8),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(18),
//                         child: Hero(
//                           tag: 'pet_${pet.id}', // Unique Hero tag for each pet
//                           child: Stack(
//                             children: [
//                               Image.network(
//                                 pet.url.isNotEmpty ? pet.url : '',
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return const Center(
//                                     child: Icon(
//                                       Icons.broken_image,
//                                       color: Colors.grey,
//                                     ),
//                                   );
//                                 },
//                               ),
//                               if (isAdopted(pet.id))
//                                 Container(
//                                   color: Colors.black.withOpacity(0.5),
//                                   alignment: Alignment.center,
//                                   child: const Text(
//                                     "Already Adopted",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           pet.breeds[0].name.length > 10
//                               ? pet.breeds[0].name.substring(0, 8)
//                               : pet.breeds[0].name,
//                           style: Theme.of(context).textTheme.bodyText1,
//                         ),
//                         GestureDetector(
//                           onTap: () => toggleFavorite(pet.id),
//                           child: Obx(() {
//                             return Icon(
//                               Icons.favorite,
//                               color: toggleFavorite(pet.id)
//                                   ? Colors.red
//                                   : Colors.grey,
//                             );
//                           }),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
