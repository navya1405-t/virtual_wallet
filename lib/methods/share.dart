// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../class/displayCard.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:pdf/pdf.dart';

Future<void> shareCard(BuildContext context, DisplayCard card) async {
  try {
    // helper to load bytes from network or file path
    Future<Uint8List?> loadBytes(String? pathOrUrl) async {
      if (pathOrUrl == null || pathOrUrl.isEmpty) return null;
      final uri = Uri.tryParse(pathOrUrl);
      final isNetwork =
          uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
      if (isNetwork) {
        final resp = await http.get(uri);
        if (resp.statusCode == 200) return resp.bodyBytes;
        return null;
      } else {
        final f = File(pathOrUrl);
        if (await f.exists()) return await f.readAsBytes();
        return null;
      }
    }

    final frontBytes = await loadBytes(card.frontPictureUrl);
    final backBytes = await loadBytes(card.backPictureUrl);

    if (frontBytes == null && backBytes == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No images available to share')),
      );
      return;
    }

    final pdf = pw.Document();

    // add a page per available image
    if (frontBytes != null) {
      final image = pw.MemoryImage(frontBytes);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(200, 200),
          build: (pw.Context ctx) {
            return pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain));
          },
        ),
      );
    }

    if (backBytes != null) {
      final image = pw.MemoryImage(backBytes);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(200, 200),
          build: (pw.Context ctx) {
            return pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain));
          },
        ),
      );
    }

    final bytes = await pdf.save();
    final tempDir = await getTemporaryDirectory();
    final fileNameSafe = card.filename.replaceAll(RegExp(r'[^\w\-\. ]'), '_');
    final outFile = File('${tempDir.path}/$fileNameSafe-cards.pdf');
    await outFile.writeAsBytes(bytes);

    if (!context.mounted) return;
    await Share.shareXFiles([
      XFile(outFile.path),
    ], text: 'Documents for "${card.filename}"');
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Share failed: $e')));
  }
}
