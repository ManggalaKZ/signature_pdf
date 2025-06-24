import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature_pdf/app/routes/app_routes.dart';

class Beranda extends StatelessWidget {
  const Beranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.WORDPDF);
                },
                child: const Text("Convert Word to PDF"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print("Navigasi ke: ${AppRoutes.HOME_SIGNATURE}");
                  Get.toNamed(AppRoutes.HOME_SIGNATURE);
                },
                child: const Text("Signature PDF"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
