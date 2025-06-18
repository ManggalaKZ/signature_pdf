import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as m;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature_pdf/app/modules/home/views/signature_pdf_preview.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/gestures.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vector_math/vector_math_64.dart';

class HomeController extends GetxController {
  final String assetPath = 'assets/contohpdf.pdf';

  RxBool isSigningMode = false.obs;
  Rx<Offset?> tappedPosition = Rx<Offset?>(null);
  Rx<Uint8List?> signatureImage = Rx<Uint8List?>(null);
  late Size pdfViewSize;

  final pdfViewerController = PdfViewerController();
  final TransformationController pdfTransformController =
      TransformationController();

  Future<void> addSignature({
    required Size pdfViewSize,
  }) async {
    if (tappedPosition.value == null || signatureImage.value == null) return;

    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final PdfDocument document = PdfDocument(inputBytes: bytes);
    final Offset tapOffset = tappedPosition.value!;
    final PdfPage page = document.pages[0];
    final Size pageSize = page.size;

    final double scaleX = pdfViewSize.width / pageSize.width;
    final double displayedPageHeight = pageSize.height * scaleX;
    final double verticalMargin =
        (pdfViewSize.height - displayedPageHeight) / 2;
    final double correctedScreenY = tapOffset.dy - verticalMargin;
    
    final double clampedScreenY =
        correctedScreenY.clamp(0.0, displayedPageHeight);
    final double pdfX = tapOffset.dx / scaleX;
    final double pdfYFromTop = clampedScreenY / scaleX;

    print("DEBUG: Posisi tap di layar: $tapOffset");
    print("DEBUG: Ukuran viewer di layar: $pdfViewSize");
    print("DEBUG: Ukuran halaman PDF: $pageSize");
    print("DEBUG: scaleX: $scaleX");
    print("DEBUG: verticalMargin: $verticalMargin");
    print("DEBUG: correctedScreenY: $correctedScreenY");
    print("DEBUG: clampedScreenY: $clampedScreenY");
    print("DEBUG: Posisi X di PDF (dari kiri): $pdfX");
    print("DEBUG: Posisi Y di PDF (dari atas): $pdfYFromTop");

    final PdfBitmap bitmap = PdfBitmap(signatureImage.value!);
    const double targetWidth = 120; 
    final double aspectRatio = bitmap.height / bitmap.width;
    final double targetHeight = targetWidth * aspectRatio;

    final double finalPdfYForDrawing =
        pageSize.height - pdfYFromTop - targetHeight;

    page.graphics.drawImage(
      bitmap,
      Rect.fromLTWH(pdfX, finalPdfYForDrawing, targetWidth, targetHeight),
    );

    final List<int> outputBytes = await document.save();
    document.dispose();

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/signed_output.pdf");
    await file.writeAsBytes(outputBytes, flush: true);

    Get.to(
      SignaturePdfPreviewView(pdfBytes: Uint8List.fromList(outputBytes)),
      transition: Transition.rightToLeft,
    );
  }
}
