import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature_pdf/app/routes/app_routes.dart';
import 'package:signature_pdf/button.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(SignaturePDFApp());
}

class SignaturePDFApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Signature PDF',
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.HOME,
    );
  }
}
