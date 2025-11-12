import 'package:flutter/material.dart';
import 'package:virtual_wallet/class/displayCard.dart';

import '../widgets/content/displayCard.dart';
import '../helpers/database.dart';
import 'overview.dart'; // added to navigate to overview and await result

class CardsHubScreen extends StatefulWidget {
  final String title;
  final String username; // username to load cards for

  const CardsHubScreen({
    super.key,
    required this.title,
    required this.username,
  });

  @override
  State<CardsHubScreen> createState() => _CardsHubScreenState();
}

class _CardsHubScreenState extends State<CardsHubScreen> {
  final List<DisplayCard> _displayCards = [];
  bool _loading = true;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() => _loading = true);
    try {
      final rows = await _dbHelper.getCardsForUser(widget.username);
      _displayCards.clear();
      for (final r in rows) {
        _displayCards.add(
          DisplayCard(
            // adapt these keys to your DisplayCard constructor
            filename: r['filename'] as String? ?? '',
            uploadedOn: r['uploaded_on'] as String? ?? '',
            frontPictureUrl: r['front_path'] as String? ?? '',
            backPictureUrl: r['back_path'] as String? ?? '',
            cardType: r['type'] as String? ?? '',
            id: r['id'].toString(),
          ),
        );
      }
    } catch (e) {
      // optional: show error
      debugPrint('Failed to load cards: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<DisplayCard> get _filteredCards {
    final title = widget.title.trim();
    if (title.isEmpty) return _displayCards;
    final lowerTitle = title.toLowerCase();
    return _displayCards.where((c) {
      final type = (c.cardType).toString().toLowerCase();
      return type == lowerTitle;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 196, 87, 154),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _filteredCards.isEmpty
          ? Center(
              child: Text(
                'No cards found for "${widget.title}"',
                style: const TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _filteredCards.length,
              itemBuilder: (context, index) {
                final card = _filteredCards[index];
                return DisplayCardWidget(
                  card: card,
                  onOpen: () async {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => OverviewScreen(card: card),
                      ),
                    );
                    if (result == true) {
                      await _loadCards();
                    }
                  },
                );
              },
            ),
    );
  }
}
