import 'package:flutter/material.dart';

import '../../screens/cardsHub.dart';
import 'card.dart';

class ListOfSections extends StatelessWidget {
  final Color primary;
  const ListOfSections({super.key, required this.primary});

  // Define sections once in a map/list
  static const List<Map<String, String>> _sections = [
    {'title': 'Proofs of Identity', 'subtitle': 'No cards to display'},
    {'title': 'Debit Cards', 'subtitle': 'No cards to display'},
    {'title': 'Credit Cards', 'subtitle': 'No cards to display'},
    {'title': 'Others', 'subtitle': 'No cards to display'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _sections.map((section) {
        final title = section['title']!;
        final subtitle = section['subtitle']!;
        return HomeSectionCard(
          title: title,
          subtitle: subtitle,
          primary: primary,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CardsHubScreen(title: title)),
            );
          },
        );
      }).toList(),
    );
  }
}
