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

  // search state
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCards();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
      _searchController.text = '';
      _searchQuery = '';
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.text = '';
      _searchQuery = '';
    });
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
    final sectionTitle = widget.title.trim();
    final lowerTitle = sectionTitle.toLowerCase();

    Iterable<DisplayCard> list = _displayCards;

    // filter by section (type) if a section title is provided
    if (sectionTitle.isNotEmpty) {
      list = list.where((c) => (c.cardType).toLowerCase() == lowerTitle);
    }

    // apply search query (search filename and type)
    if (_searchQuery.isNotEmpty) {
      list = list.where((c) {
        final filename = (c.filename).toLowerCase();
        final type = (c.cardType).toLowerCase();
        return filename.contains(_searchQuery) || type.contains(_searchQuery);
      });
    }

    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 196, 87, 154),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search for card...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.85)),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              )
            : Text(widget.title, style: const TextStyle(color: Colors.white)),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                if (_searchController.text.isEmpty) {
                  _stopSearch();
                } else {
                  _searchController.clear();
                }
              },
            ),
          // always show the search icon at the end
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: 'Search',
            onPressed: () {
              if (_isSearching) {
                _stopSearch();
              } else {
                _startSearch();
              }
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _filteredCards.isEmpty
          ? Center(
              child: Text(
                _searchQuery.isNotEmpty
                    ? 'No results for "$_searchQuery"'
                    : 'No cards found for "${widget.title}"',
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
