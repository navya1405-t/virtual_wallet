import 'package:flutter/material.dart';
import 'package:virtual_wallet/class/displayCard.dart';

import '../helpers/database.dart';

Future<void> confirmAndDelete(BuildContext context, DisplayCard card) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete card'),
      content: Text('Delete "${card.filename}"? This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  try {
    final db = DatabaseHelper();
    // expects DatabaseHelper.deleteCardByFilename to return number of rows deleted
    final deleted = await db.deleteCard(card.id);
    if (deleted > 0) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Card deleted')));
      // pop back to previous screen and signal deletion (true)
      Navigator.of(context).pop(true);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No card deleted')));
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
  }
}
