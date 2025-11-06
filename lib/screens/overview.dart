import 'package:flutter/material.dart';
import 'package:virtual_wallet/class/displayCard.dart';

import '../widgets/overview/cardside.dart';

class OverviewScreen extends StatelessWidget {
  final DisplayCard card;
  const OverviewScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final appBarHeight = kToolbarHeight + media.padding.top;
    final availableHeight = media.size.height - appBarHeight - 48;
    final imageHeight = availableHeight * 0.35;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(card.filename, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CardSide(
              title: 'Front Side',
              imageUrl: card.frontPictureUrl,
              uploadedDate: card.uploadedOn,
              imageHeight: imageHeight,
            ),
            const SizedBox(height: 20),
            CardSide(
              title: 'Back Side',
              imageUrl: card.backPictureUrl,
              uploadedDate: card.uploadedOn,
              imageHeight: imageHeight,
            ),
          ],
        ),
      ),
    );
  }
}
