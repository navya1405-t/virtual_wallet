import 'package:flutter/material.dart';
import 'package:virtual_wallet/class/displayCard.dart';

class OverviewScreen extends StatelessWidget {
  final DisplayCard card;
  const OverviewScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(card.title, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // TODO: Add share logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              // TODO: Add delete logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCardSide(
              title: "Front Side",
              imageUrl: card.frontPictureUrl,
              uploadedDate: card.uploadedOn,
            ),
            const SizedBox(height: 20),
            buildCardSide(
              title: "Back Side",
              imageUrl: card.backPictureUrl, // replace with back image
              uploadedDate: card.uploadedOn,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardSide({
    required String title,
    required String imageUrl,
    required String uploadedDate,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title bar
          Container(
            width: double.infinity,
            color: Colors.purple.shade400,
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
          // Image
          Image.network(
            imageUrl,
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
          ),
          // Bottom text
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
