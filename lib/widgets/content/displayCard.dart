import 'dart:io';
import 'package:flutter/material.dart';
import 'package:virtual_wallet/class/displayCard.dart';

import '../../methods/formattedDate.dart';

class DisplayCardWidget extends StatelessWidget {
  final DisplayCard card;
  final VoidCallback? onOpen; // added callback

  const DisplayCardWidget({super.key, required this.card, this.onOpen});

  // choose front if available, otherwise back
  String? _preferredImage(String? front, String? back) {
    if (front != null && front.isNotEmpty) return front;
    if (back != null && back.isNotEmpty) return back;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = 180;
    return InkWell(
      onTap: onOpen, // use callback instead of directly pushing
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFB388FF), width: 1.5),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and overview icon row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    card.filename,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.open_in_new_outlined,
                      color: Color(0xFF6A1B9A),
                    ),
                    onPressed: onOpen, // use same callback
                  ),
                ],
              ),
              Text(
                "Uploaded on ${formatUploadedDate(card.uploadedOn)}",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),

              // image (handles network URLs and local file paths)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImageWidget(
                  _preferredImage(card.frontPictureUrl, card.backPictureUrl),
                  height: imageHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String? pathOrUrl, {double? height}) {
    if (pathOrUrl == null || pathOrUrl.isEmpty) {
      return SizedBox(
        height: height ?? 120,
        width: double.infinity,
        child: const Center(
          child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
        ),
      );
    }

    final uri = Uri.tryParse(pathOrUrl);
    final isNetwork =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    if (isNetwork) {
      return Image.network(
        pathOrUrl,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            height: height ?? 120,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (ctx, err, st) => SizedBox(
          height: height ?? 120,
          child: const Center(child: Icon(Icons.broken_image, size: 48)),
        ),
      );
    }

    // treat as local file / content uri
    try {
      final file = File(pathOrUrl);
      return Image.file(
        file,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, st) => SizedBox(
          height: height ?? 120,
          child: const Center(child: Icon(Icons.broken_image, size: 48)),
        ),
      );
    } catch (_) {
      return SizedBox(
        height: height ?? 120,
        child: const Center(child: Icon(Icons.broken_image, size: 48)),
      );
    }
  }
}
