import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature_pdf/app/modules/homeSignature/widgets/signature_draw_dialog.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../controllers/home_controller.dart';

class HomeViewSignature extends GetView<HomeController> {
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signature PDF')),
      body: Obx(() {
        return Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                controller.pdfViewSize =
                    Size(constraints.maxWidth, constraints.maxHeight);
                return SfPdfViewer.asset(
                  'assets/laporanAM.pdf',
                  key: pdfViewerKey,
                  controller: controller.pdfViewerController,
                  pageLayoutMode: PdfPageLayoutMode.single,
                  scrollDirection: PdfScrollDirection.vertical,
                );
              },
            ),
            if (controller.isSigningMode.value)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (TapUpDetails details) async {
                    final currentPage = controller.currentPageNumber.value;
                    print("DEBUG: Current page number: $currentPage");
                    final tapPos = details.localPosition;
                    print("DEBUG: Tap position: $tapPos");

                    controller.tappedPosition.value = tapPos;
                    controller.isSigningMode.value = false;

                    final result = await showDialog<Uint8List>(
                      context: context,
                      builder: (_) => const SignatureDrawDialog(),
                    );

                    if (result != null) {
                      controller.signatureImage.value = result;
                      await controller.addSignature(
                          pageNumber: currentPage,
                          pdfViewSize: controller.pdfViewSize);
                    }
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    alignment: Alignment.center,
                    child: const Text(
                      "Tap dimana saja untuk memberi tanda tangan",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.isSigningMode.value = true;
          print("Signing mode ON");
        },
        label: Text("Beri Tanda Tangan"),
        icon: Icon(Icons.edit),
      ),
    );
  }
}
