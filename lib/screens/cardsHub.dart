import 'package:flutter/material.dart';
import 'package:virtual_wallet/class/displayCard.dart';

import '../widgets/content/displayCard.dart';

class CardsHubScreen extends StatefulWidget {
  final String title;
  const CardsHubScreen({super.key, required this.title});

  @override
  State<CardsHubScreen> createState() => _CardsHubScreenState();
}

class _CardsHubScreenState extends State<CardsHubScreen> {
  final List<DisplayCard> displayCards = [
    DisplayCard(
      title: 'Aadhar',
      uploadedOn: 'Oct 29, 2025',
      pictureUrl:
          'https://images.unsplash.com/photo-1603415526960-f7e0328f8f1b?auto=format&fit=crop&w=800&q=80',
    ),
    DisplayCard(
      title: 'Driving License',
      uploadedOn: 'Oct 25, 2025',
      pictureUrl:
          'https://images.unsplash.com/photo-1502764613149-7f1d229e230f?auto=format&fit=crop&w=800&q=80',
    ),
    DisplayCard(
      title: 'Passport',
      uploadedOn: 'Oct 20, 2025',
      pictureUrl:
          'https://images.unsplash.com/photo-1504196606672-aef5c9cefc92?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 196, 87, 154),
      ),
      body: ListView.builder(
        itemCount: displayCards.length,
        itemBuilder: (context, index) =>
            DisplayCardWidget(
                  title: displayCards[index].title,
                  uploadedOn: displayCards[index].uploadedOn,
                  pictureUrl: displayCards[index].pictureUrl,
                )
                as Widget?,
      ),
    );
  }
}
