import 'package:flutter/material.dart';

import '../../screens/cardsHub.dart';
import 'card.dart';
import '../../helpers/database.dart';

class ListOfSections extends StatefulWidget {
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
  State<ListOfSections> createState() => _ListOfSectionsState();
}

class _ListOfSectionsState extends State<ListOfSections> {
  final DatabaseHelper _db = DatabaseHelper();
  final Map<String, int> _counts = {
    for (var t in ListOfSections._sectionTitles) t: 0,
  };
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    setState(() => _loading = true);
    try {
      final rows = await _db.getCardsForUser(widget.username);
      final Map<String, int> counts = {
        for (var t in ListOfSections._sectionTitles) t: 0,
      };
      for (final r in rows) {
        final type = (r['type'] as String?) ?? 'Others';
        if (counts.containsKey(type)) {
          counts[type] = counts[type]! + 1;
        } else {
          // non-listed types go to Others
          counts['Others'] = (counts['Others'] ?? 0) + 1;
        }
      }
      if (mounted) {
        setState(() {
          _counts
            ..clear()
            ..addAll(counts);
        });
      }
    } catch (e) {
      debugPrint('Failed to load section counts: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // call this from parent after returning from upload
  Future<void> refreshCounts() async {
    await _loadCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ListOfSections._sectionTitles.map((title) {
        final count = _counts[title] ?? 0;
        final subtitle = _loading
            ? 'Loading...'
            : (count == 0
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
            // If child signalled a change (deleted/uploaded) or returned any true,
            // refresh the counts so the list updates immediately.
            if (result == true) {
              await _loadCounts();
            } else {
              // also refresh to catch changes even if child didn't explicitly return true
              await _loadCounts();
            }
          },
        );
      }).toList(),
    );
  }
}
