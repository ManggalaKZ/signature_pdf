import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature_pdf/app/controllers/convert_wordpdf_controller.dart';

class ConvertWordpdf extends GetView<ConvertController> {
  const ConvertWordpdf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Convert Word to PDF"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final file = controller.selectedFile.value;
          return Column(
            children: [
              ElevatedButton.icon(
                onPressed: controller.pickDocxFile,
                icon: const Icon(Icons.attach_file),
                label: const Text("Pilih File .docx"),
              ),
              const SizedBox(height: 10),
              if (file != null)
                Text("Dipilih: ${file.path.split('/').last}"),
              const Spacer(),
              ElevatedButton(
                onPressed: file == null
                    ? null
                    : () {
                        controller.convertToPdf(file);
                      },
                child: const Text("Convert ke PDF"),
              ),
            ],
          );
        }),
      ),
    );
  }
}
