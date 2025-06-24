import 'package:get/get.dart';
import 'package:signature_pdf/app/bindings/convert_pdfword_bindings.dart';
import 'package:signature_pdf/app/bindings/home_bindings.dart';
import 'package:signature_pdf/app/modules/beranda.dart';
import 'package:signature_pdf/app/modules/convert/views/convert_wordpdf.dart';
import 'package:signature_pdf/app/modules/homeSignature/views/home_views.dart';
import 'package:signature_pdf/app/routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => Beranda(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME_SIGNATURE,
      page: () => HomeViewSignature(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.WORDPDF,
      page: () => ConvertWordpdf(),
      binding: ConvertPdfwordBindings(),
    ),
  ];
}
