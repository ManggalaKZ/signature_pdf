import 'dart:io';
import 'dart:math' as m;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature_pdf/app/modules/home/views/signature_pdf_preview.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HomeController extends GetxController {
  final String assetPath = 'assets/laporanAM.pdf';

  RxBool isSigningMode = false.obs;
  Rx<Offset?> tappedPosition = Rx<Offset?>(null);
  Rx<Uint8List?> signatureImage = Rx<Uint8List?>(null);
  late Size pdfViewSize;
  final currentPageNumber = 1.obs;

  final pdfViewerController = PdfViewerController();
  final TransformationController pdfTransformController =
      TransformationController();

  @override
  void onInit() {
    super.onInit();
    pdfViewerController.addListener(() {
      currentPageNumber.value = pdfViewerController.pageNumber;
    });
  }

  Future<void> addSignature({
    required Size pdfViewSize,
    required int pageNumber,
  }) async {
    if (tappedPosition.value == null || signatureImage.value == null) return;

    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    final Offset tapOffset = tappedPosition.value!;
    final int pageCount = document.pages.count;
    final Size firstPageSize = document.pages[0].size;

    final double scaleX = pdfViewSize.width / firstPageSize.width;
    final double displayedPageHeight = firstPageSize.height * scaleX;
    final double verticalMargin =
        (pdfViewSize.height - displayedPageHeight) / 2;
    final double totalHeightPerPage =
        displayedPageHeight + (verticalMargin * 2);

    // 👇 Hitung halaman berdasarkan posisi ketukan Y
    final int tappedPageIndex =
        (tapOffset.dy / totalHeightPerPage).floor().clamp(0, pageCount - 1);
    print("Menambahkan TTD ke halaman sebelum di $pageNumber");
    final PdfPage page = document.pages[pageNumber - 1];
     print("Menambahkan TTD ke halaman $pageNumber");
    final Size pageSize = page.size;

    final double correctedScreenY =
        tapOffset.dy - (tappedPageIndex * totalHeightPerPage) - verticalMargin;
    final double clampedScreenY =
        correctedScreenY.clamp(0.0, displayedPageHeight);
    final double pdfX = tapOffset.dx / scaleX;
    final double pdfYFromTop = clampedScreenY / scaleX;

    print("DEBUG: Tap di layar: $tapOffset");
    print("DEBUG: Tap dikenali di halaman ke: ${tappedPageIndex }");
    print("DEBUG: Ukuran viewer: $pdfViewSize");
    print("DEBUG: Ukuran halaman PDF: $pageSize");
    print("DEBUG: Posisi X di PDF (dari kiri): $pdfX");
    print("DEBUG: Posisi Y di PDF (dari atas): $pdfYFromTop");

    final PdfBitmap bitmap = PdfBitmap(signatureImage.value!);
    const double targetWidth = 100;
    final double aspectRatio = bitmap.height / bitmap.width;
    final double targetHeight = targetWidth * aspectRatio;

    page.graphics.drawImage(
      bitmap,
      Rect.fromLTWH(pdfX - 20, pdfYFromTop - 20, targetWidth, targetHeight),
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

  // // Tambahkan method ini di controller
  // int getTappedPage(Offset tapPositionInViewer) {
  //   final zoom = pdfViewerController.zoomLevel;
  //   final viewerSize = pdfViewSize;
  //   final pageOffsets = pdfViewerController.pageOffsets;

  //   double y = tapPositionInViewer.dy + pdfViewerController.scrollOffset.dy;

  //   for (int i = 0; i < pageOffsets.length; i++) {
  //     final pageTop = pageOffsets[i];
  //     final pageBottom =
  //         pageTop + pdfViewerController.pagesize[i].height * zoom;

  //     if (y >= pageTop && y <= pageBottom) {
  //       return i +
  //           1; // karena index mulai dari 0, sedangkan halaman mulai dari 1
  //     }
  //   }

  //   return 1; // fallback default halaman 1
  // }
}
