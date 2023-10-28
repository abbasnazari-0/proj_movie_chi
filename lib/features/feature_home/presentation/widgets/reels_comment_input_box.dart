import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/home_page_controller.dart';

import '../../data/model/home_reels_model.dart';

class ReelUserInputComment extends StatelessWidget {
  ReelUserInputComment(
      {super.key, required this.size, required this.reelsModel});

  final Size size;

  final controller = Get.find<HomePageController>();
  final ReelsModel reelsModel;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: Colors.white.withAlpha(80)),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: controller.commentController,
                  decoration: InputDecoration(
                    hintText: 'دیدگاه خود را بنویسید',
                    hintStyle: TextStyle(
                      color: Colors.white.withAlpha(100),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.white.withAlpha(80)),
              height: 40,
              width: 40,
              child: Center(
                child: IconButton(
                  icon: const Icon(Iconsax.send_24),
                  onPressed: () {
                    controller.sendReelsComment(
                        controller.commentController.text, reelsModel.tag!);
                  },
                ),
              ),
            ),
            SizedBox(width: size.width * 0.02),
          ],
        ));
  }
}
