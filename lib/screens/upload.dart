import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/database.dart';
import '../widgets/upload/controls.dart';
import '../widgets/upload/imageCard.dart';

class UploadScreen extends StatefulWidget {
  final String username;
  const UploadScreen({super.key, required this.username});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _fileNameController = TextEditingController();
  String? selectedCardType;
  File? frontImage;
  File? backImage;

  final ImagePicker _picker = ImagePicker();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final List<String> cardTypes = [
    'Proofs of Identity',
    'Debit Cards',
    'Credit Cards',
    'Others',
  ];

  Future<void> _pickImage(bool isFront, ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;
    setState(() {
      if (isFront) {
        frontImage = File(picked.path);
      } else {
        backImage = File(picked.path);
      }
    });
  }

  Future<void> _deleteImage(bool isFront) async {
    setState(() {
      if (isFront) {
        frontImage = null;
      } else {
        backImage = null;
      }
    });
  }

  Future<void> _saveCardToDb() async {
    final filename = _fileNameController.text.trim();
    if (selectedCardType == null ||
        filename.isEmpty ||
        (frontImage == null && backImage == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose type, filename and at least one image'),
        ),
      );
      return;
    }

    final user = await _dbHelper.getUserByUsername(widget.username);
    if (user == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found. Please login again.')),
      );
      return;
    }

    final int userId = user['id'] as int;
    final cardMap = {
      'type': selectedCardType,
      'filename': filename,
      'front_path': frontImage?.path,
      'back_path': backImage?.path,
      'uploaded_on': DateTime.now().toIso8601String(),
      'user_id': userId,
    };

    try {
      final id = await _dbHelper.saveCard(cardMap);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Card saved (id: $id)')));
      setState(() {
        frontImage = null;
        backImage = null;
        _fileNameController.clear();
        selectedCardType = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    }
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final appBarHeight = kToolbarHeight + media.padding.top;
    final availableHeight = media.size.height - appBarHeight - 32;
    final imageBlockHeight = availableHeight * 0.3;
    final controlsHeight = availableHeight * 0.25;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Upload Card'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              UploadControls(
                cardTypes: cardTypes,
                selectedType: selectedCardType,
                onTypeChanged: (v) => setState(() => selectedCardType = v),
                fileNameController: _fileNameController,
                controlsHeight: controlsHeight,
                onSave: _saveCardToDb,
              ),
              const SizedBox(height: 8),
              UploadImageCard(
                label: 'Front Side',
                imageFile: frontImage,
                height: imageBlockHeight,
                onPickCamera: () => _pickImage(true, ImageSource.camera),
                onPickGallery: () => _pickImage(true, ImageSource.gallery),
                onDelete: () => _deleteImage(true),
              ),
              UploadImageCard(
                label: 'Back Side',
                imageFile: backImage,
                height: imageBlockHeight,
                onPickCamera: () => _pickImage(false, ImageSource.camera),
                onPickGallery: () => _pickImage(false, ImageSource.gallery),
                onDelete: () => _deleteImage(false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
