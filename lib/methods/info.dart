// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

void ShowAboutDialog(BuildContext context, String username) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF6A1B9A),
            child: Icon(Icons.account_balance_wallet, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Text('About Virtual Wallet'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Virtual Wallet helps you store and manage images of important cards and documents securely on your device.',
            ),
            const SizedBox(height: 12),
            Text(
              'Signed in as: ${username.isNotEmpty ? username : "Unknown"}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Text(
              'Key features:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              '• Add photos of IDs, debit/credit cards and other documents.',
            ),
            const Text(
              '• View front/back images, share as a single PDF, or delete items.',
            ),
            const SizedBox(height: 8),
            const Text(
              'Privacy & storage',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'All images and data are stored locally on your device in the app\'s private folder. '
              'They are not uploaded to any server by the app.',
            ),
            const SizedBox(height: 8),
            const Text('Tips', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const Text(
              '• Use clear photos and keep both front and back for completeness.',
            ),
            const Text(
              '• Use the share button on an item to create a PDF for secure sharing.',
            ),
            const SizedBox(height: 10),
            const Text(
              'If you need help or want to report an issue, email: navyareddyturimerla@gmail.com',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
