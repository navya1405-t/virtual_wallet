// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';

class UploadImageCard extends StatelessWidget {
  final String label;
  final File? imageFile;
  final double height;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
  final VoidCallback onDelete;

  const UploadImageCard({
    super.key,
    required this.label,
    required this.imageFile,
    required this.height,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: imageFile == null ? _emptyView(context) : _previewView(context),
    );
  }

  Widget _emptyView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt, size: 28, color: Colors.grey),
              onPressed: onPickCamera,
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.image, size: 28, color: Colors.grey),
              onPressed: onPickGallery,
            ),
          ],
        ),
      ],
    );
  }

  Widget _previewView(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            imageFile!,
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ],
    );
  }
}
