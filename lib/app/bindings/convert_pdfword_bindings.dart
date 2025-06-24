import 'package:get/get.dart';
import 'package:signature_pdf/app/controllers/convert_wordpdf_controller.dart';

class ConvertPdfwordBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConvertController>(() => ConvertController());
  }
}
