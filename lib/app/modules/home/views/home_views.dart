import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature_pdf/app/modules/home/widgets/signature_draw_dialog.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../controllers/home_controller.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class HomeView extends GetView<HomeController> {
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signature PDF')),
      body: Stack(
        children: [
          InteractiveViewer(
              transformationController: controller.pdfTransformController,
              minScale: 1.0,
              maxScale: 5.0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  controller.pdfViewSize =
                      Size(constraints.maxWidth, constraints.maxHeight);
                  return Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: SfPdfViewer.asset(
                      'assets/contohpdf.pdf',
                      controller: controller.pdfViewerController,
                    ),
                  );
                },
              )),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapUp: (TapUpDetails details) async {
                final tapPos = details.localPosition;
                print("DEBUG: User tap position (localPosition): $tapPos");
                if (controller.isSigningMode.value) {
                  final Matrix4 inverse =
                      Matrix4.inverted(controller.pdfTransformController.value);
                  final vector = inverse.transform3(vm.Vector3(
                      details.localPosition.dx, details.localPosition.dy, 0));
                  final transformedTap = Offset(vector.x, vector.y);

                  controller.tappedPosition.value = transformedTap;
                  print(
                      "DEBUG: Tap position after inverse transform: $transformedTap");

                  controller.isSigningMode.value = false;

                  final result = await showDialog<Uint8List>(
                    context: context,
                    builder: (_) => const SignatureDrawDialog(),
                  );

                  if (result != null) {
                    controller.signatureImage.value = result;
                    await controller.addSignature(
                        pdfViewSize: controller.pdfViewSize);
                  }
                }
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          Obx(() => controller.isSigningMode.value
              ? IgnorePointer(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    alignment: Alignment.center,
                    child: const Text(
                      "Tap dimana saja untuk memberi tanda tangan",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
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
