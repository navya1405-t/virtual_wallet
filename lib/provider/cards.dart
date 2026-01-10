import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtual_wallet/class/displayCard.dart';

// 1. THE NOTIFIER
// purely manages the List<DisplayCard> in memory.
class CardsNotifier extends StateNotifier<List<DisplayCard>> {
  // Initialize with an empty list
  CardsNotifier() : super([]);

  // A. SET: Use this to load the initial list from the DB
  void setCards(List<DisplayCard> cards) {
    state = cards;
  }

  // B. ADD: Adds a card to the top of the list
  void addCard(DisplayCard card) {
    // We create a new list with the new card at the start + existing cards
    state = [card, ...state];
  }

  // C. DELETE: Removes a card by ID
  void removeCard(String id) {
    state = state.where((card) => card.id != id).toList();
  }

  // D. UPDATE: Replaces a specific card (useful after editing)
  void updateCard(DisplayCard updatedCard) {
    state = [
      for (final card in state)
        if (card.id == updatedCard.id) updatedCard else card,
    ];
  }
}

// 2. THE PROVIDER
// I use .family if you need separate lists for separate users,
// otherwise a simple StateNotifierProvider works.
final cardsProvider =
    StateNotifierProvider.family<CardsNotifier, List<DisplayCard>, String>(
      (ref, username) => CardsNotifier(),
    );
