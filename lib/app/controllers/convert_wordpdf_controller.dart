import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aspose_words_cloud/aspose_words_cloud.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature_pdf/app/modules/convert/views/pdf_preview.dart';

class ConvertController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);

  final String clientId = '3f200088-8ad4-4f81-9dc2-1693630f6a0b';
  final String clientSecret = '5c7c2cf524e6ba2d9987850d777b0e89';

  late WordsApi wordsApi;

  @override
  void onInit() {
    super.onInit();
    final config = Configuration(clientId, clientSecret);
    wordsApi = WordsApi(config);
  }

  Future<void> pickDocxFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx'],
    );

    if (result != null && result.files.single.path != null) {
      selectedFile.value = File(result.files.single.path!);
    }
  }

  Future<void> convertToPdf(File docxFile) async {
    final cloudFileName = 'temp_upload.docx';
    final outputPdfName = 'converted_output.pdf';

    try {
      // Step 1: Upload file ke Aspose Cloud
      final bytes = await docxFile.readAsBytes();
      final byteData = ByteData.view(bytes.buffer);
      final uploadRequest = UploadFileRequest(byteData, cloudFileName);
      await wordsApi.uploadFile(uploadRequest);

      // Step 2: Konversi file menjadi PDF
      final saveOptions = PdfSaveOptionsData()..fileName = outputPdfName;
      final saveAsRequest = SaveAsRequest(cloudFileName, saveOptions);
      await wordsApi.saveAs(saveAsRequest);

      // Step 3: Unduh hasil PDF dari cloud
      final downloadRequest = DownloadFileRequest(outputPdfName);
      final response = await wordsApi.downloadFile(downloadRequest);

      // Simpan hasil unduhan ke file lokal
      final dir = await getTemporaryDirectory();
      final pdfFile = File('${dir.path}/$outputPdfName');
      await pdfFile.writeAsBytes(response.buffer.asUint8List());

      Get.snackbar("Sukses", "File berhasil dikonversi");

      // Navigasi ke halaman preview PDF dengan mengirim objek File
      Get.to(() => PdfPreviewPage(pdfFile: pdfFile));
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Gagal mengonversi file");
    }
  }

  Future<bool> requestStoragePermission() async {
    final status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      final result = await Permission.manageExternalStorage.request();
      return result.isGranted;
    }
    return true;
  }
}
