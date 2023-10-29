import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_support/presentation/controllers/support_page_controller.dart';

class SupportHeader extends StatelessWidget {
  SupportHeader({
    super.key,
  });

  final cont = Get.find<SupportPageController>();

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
          SizedBox(width: 0.02.sw),
          CircleAvatar(
            radius: 0.03.sh,
            backgroundImage: const NetworkImage(
                'https://avatars.githubusercontent.com/u/60203108?v=4'),
          ),
          SizedBox(width: 0.02.sw),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                txt: 'پشتیبان مووی چی',
                color: Colors.white,
                size: 15.sp,
                fontWeight: FontWeight.bold,
              ),
              MyText(
                txt: "سرعت پاسخگویی معمولا کمتر از 10 دقیقه است",
                color: Colors.white,
                size: 10.sp,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Iconsax.refresh4),
            onPressed: () {
              cont.refreshAgain();
            },
          ),
        ],
      ),
    );
  }
}
