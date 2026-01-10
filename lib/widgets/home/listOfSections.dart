import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtual_wallet/provider/cards.dart';

import '../../screens/cardsHub.dart';
import 'card.dart';
import '../../helpers/database.dart';

class ListOfSections extends ConsumerStatefulWidget {
  final Color primary;
  final String username;
  const ListOfSections({
    super.key,
    required this.primary,
    required this.username,
  });

  // Define sections once in a map/list
  static const List<String> _sectionTitles = [
    'Proofs of Identity',
    'Debit Cards',
    'Credit Cards',
    'Others',
  ];

  @override
  ConsumerState<ListOfSections> createState() => _ListOfSectionsState();
}

class _ListOfSectionsState extends ConsumerState<ListOfSections> {
  @override
  Widget build(BuildContext context) {
    final allCards = ref.watch(cardsProvider(widget.username));
    return Column(
      children: ListOfSections._sectionTitles.map((title) {
        //final count = _counts[title] ?? 0;
        final count = allCards
            .where((c) => c.cardType.toLowerCase() == title.toLowerCase())
            .length;
        final subtitle = (count == 0
            ? 'No cards to display'
            : (count == 1)
            ? '$count card to display'
            : '$count cards to display');
        return HomeSectionCard(
          title: title,
          subtitle: subtitle,
          primary: widget.primary,
          onTap: () async {
            // Await the pushed screen and reload counts when it returns.
            final result = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) =>
                    CardsHubScreen(title: title, username: widget.username),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
