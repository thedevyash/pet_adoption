import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageZoomView extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const ImageZoomView(
      {super.key, required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            panEnabled: true, // Enable panning
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 1.0, // Minimum zoom scale
            maxScale: 4.0, // Maximum zoom scale
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 50,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
