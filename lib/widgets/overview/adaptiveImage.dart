import 'dart:io';

import 'package:flutter/material.dart';

class AdaptiveImage extends StatelessWidget {
  final String? pathOrUrl;
  final double? height;

  const AdaptiveImage({super.key, required this.pathOrUrl, this.height});

  @override
  Widget build(BuildContext context) {
    final displayHeight = height ?? 200.0;

    if (pathOrUrl == null || pathOrUrl!.isEmpty) {
      return SizedBox(
        height: displayHeight,
        child: const Center(child: Icon(Icons.broken_image, size: 48)),
      );
    }

    final uri = Uri.tryParse(pathOrUrl!);
    final isNetwork =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    // Use BoxFit.contain so the full image is visible (no cropping).
    // Keep width infinite so it centers/letterboxes correctly inside the card.
    if (isNetwork) {
      return SizedBox(
        width: double.infinity,
        height: displayHeight,
        child: Image.network(
          pathOrUrl!,
          fit: BoxFit.contain,
          alignment: Alignment.center,
          loadingBuilder: (ctx, child, progress) {
            if (progress == null) return child;
            return SizedBox(
              height: displayHeight,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (ctx, err, st) => SizedBox(
            height: displayHeight,
            child: const Center(child: Icon(Icons.broken_image, size: 48)),
          ),
        ),
      );
    }

    try {
      final file = File(pathOrUrl!);
      return SizedBox(
        width: double.infinity,
        height: displayHeight,
        child: Image.file(
          file,
          fit: BoxFit.contain,
          alignment: Alignment.center,
          errorBuilder: (ctx, err, st) => SizedBox(
            height: displayHeight,
            child: const Center(child: Icon(Icons.broken_image, size: 48)),
          ),
        ),
      );
    } catch (_) {
      return SizedBox(
        height: displayHeight,
        child: const Center(child: Icon(Icons.broken_image, size: 48)),
      );
    }
  }
}
