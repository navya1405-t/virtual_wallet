import 'package:flutter/material.dart';

import 'adaptiveImage.dart';

class CardSide extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String uploadedDate;
  final double imageHeight;

  const CardSide({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.uploadedDate,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title bar
          Container(
            width: double.infinity,
            color: Colors.black54,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          // adaptive image
          AdaptiveImage(pathOrUrl: imageUrl, height: imageHeight),
          // footer
          Container(
            color: Colors.black54,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Text(
              "Uploaded on $uploadedDate",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
