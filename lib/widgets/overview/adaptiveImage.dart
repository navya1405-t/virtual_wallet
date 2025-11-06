import 'dart:io';

import 'package:flutter/material.dart';

class AdaptiveImage extends StatelessWidget {
  final String? pathOrUrl;
  final double? height;

  const AdaptiveImage({super.key, required this.pathOrUrl, this.height});

  @override
  Widget build(BuildContext context) {
    if (pathOrUrl == null || pathOrUrl!.isEmpty) {
      return SizedBox(
        height: height ?? 200,
        child: const Center(child: Icon(Icons.broken_image, size: 48)),
      );
    }

    final uri = Uri.tryParse(pathOrUrl!);
    final isNetwork =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    if (isNetwork) {
      return Image.network(
        pathOrUrl!,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            height: height ?? 200,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (ctx, err, st) => SizedBox(
          height: height ?? 200,
          child: const Center(child: Icon(Icons.broken_image, size: 48)),
        ),
      );
    }

    try {
      final file = File(pathOrUrl!);
      return Image.file(
        file,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, st) => SizedBox(
          height: height ?? 200,
          child: const Center(child: Icon(Icons.broken_image, size: 48)),
        ),
      );
    } catch (_) {
      return SizedBox(
        height: height ?? 200,
        child: const Center(child: Icon(Icons.broken_image, size: 48)),
      );
    }
  }
}
