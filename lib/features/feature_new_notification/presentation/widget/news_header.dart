import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_new_notification/presentation/controllers/news_page_controller.dart';

class NewsHeader extends StatelessWidget {
  NewsHeader({
    super.key,
  });

  final cont = Get.find<NewsPageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      // height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Iconsax.arrow_right_1),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Gap(1),
          const CircleAvatar(
            radius: 0.03,
            backgroundImage: AssetImage(
              'assets/images/icon.png',
            ),
          ),
          const Gap(1),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                txt: 'اطلاع رسانی مووی چی',
                color: Colors.white,
                size: 15,
                fontWeight: FontWeight.bold,
              ),
              MyText(
                txt: "اطلاع رسانی های مهم در این قسمت قرار میگیرد",
                color: Colors.white,
                size: 10,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
