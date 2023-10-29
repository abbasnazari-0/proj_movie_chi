import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/features/feature_support/presentation/controllers/support_page_controller.dart';
import 'package:movie_chi/features/feature_support/presentation/widget/support_content.dart';
import 'package:movie_chi/features/feature_support/presentation/widget/support_header.dart';
import 'package:movie_chi/features/feature_support/presentation/widget/support_typing.dart';
import 'package:movie_chi/locator.dart';

class SupportPage extends StatelessWidget {
  SupportPage({super.key});
  final supportController =
      Get.put(SupportPageController(supportUseCase: locator()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              SupportHeader(),
              const SupportContent(),
              const TypingSection()
            ],
          ),
        ),
      ),
    );
  }
}
