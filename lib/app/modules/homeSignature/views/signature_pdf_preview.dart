import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SignaturePdfPreviewView extends StatelessWidget {
  final Uint8List pdfBytes;

  const SignaturePdfPreviewView({super.key, required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview PDF')),
      body: SfPdfViewer.memory(pdfBytes),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Simpan"),
        icon: Icon(Icons.save),
        onPressed: () async {
          final dir = await getTemporaryDirectory();
          final file = File("${dir.path}/signed_output.pdf");
          await file.writeAsBytes(pdfBytes, flush: true);
          Navigator.pop(context);
        },
      ),
    );
  }
}