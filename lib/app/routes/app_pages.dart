import 'package:get/get.dart';
import 'package:signature_pdf/app/bindings/home_bindings.dart';
import 'package:signature_pdf/app/modules/home/views/home_views.dart';
import 'package:signature_pdf/app/routes/app_routes.dart';


class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
