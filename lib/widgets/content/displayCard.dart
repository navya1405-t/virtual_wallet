import 'package:flutter/material.dart';

class DisplayCardWidget {
  final String title;
  final String uploadedOn;
  final String pictureUrl;

  DisplayCardWidget({
    required this.title,
    required this.uploadedOn,
    required this.pictureUrl,
  });
}

class AadharCardWidget extends StatelessWidget {
  final DisplayCardWidget card;

  const AadharCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFB388FF), width: 1.5),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and overview icon row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.visibility_outlined,
                    color: Color(0xFF6A1B9A),
                  ),
                  onPressed: () {
                    // Handle overview action
                  },
                ),
              ],
            ),
            Text(
              'Uploaded on ${card.uploadedOn}',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                card.pictureUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
