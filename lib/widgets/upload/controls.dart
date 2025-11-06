// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class UploadControls extends StatelessWidget {
  final List<String> cardTypes;
  final String? selectedType;
  final ValueChanged<String?> onTypeChanged;
  final TextEditingController fileNameController;
  final double controlsHeight;
  final VoidCallback onSave;

  const UploadControls({
    super.key,
    required this.cardTypes,
    required this.selectedType,
    required this.onTypeChanged,
    required this.fileNameController,
    required this.controlsHeight,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: controlsHeight,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            value: selectedType,
            hint: const Text('Choose card type'),
            items: cardTypes
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: onTypeChanged,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: fileNameController,
            decoration: const InputDecoration(
              labelText: 'Filename',
              border: UnderlineInputBorder(),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onSave,
              child: const Text(
                'SAVE',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
