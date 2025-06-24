import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature_pdf/app/controllers/convert_wordpdf_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class PdfPreviewPage extends StatelessWidget {
  final File pdfFile;
  const PdfPreviewPage({super.key, required this.pdfFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview PDF"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () async {
              ConvertController controller = Get.find<ConvertController>();
              controller.requestStoragePermission();
              final selectedDirectory =
                  await FilePicker.platform.getDirectoryPath();
              if (selectedDirectory == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Penyimpanan dibatalkan")),
                );
                return;
              }

              final newPath =
                  '$selectedDirectory/${pdfFile.path.split('/').last}';
              final newFile = await pdfFile.copy(newPath);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("File berhasil disimpan di: $newPath")),
              );
              print("File PDF disimpan di: $newPath");
            },
          ),
        ],
      ),
      body: FutureBuilder<int>(
        future: pdfFile.length(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data! > 0) {
              return SfPdfViewer.file(
                pdfFile,
                pageLayoutMode: PdfPageLayoutMode.single,
                scrollDirection: PdfScrollDirection.vertical,
              );
            } else {
              return Center(
                  child: Text("File PDF kosong atau tidak ditemukan"));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
