import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/utils/report_videi_bug.dart';
import 'package:movie_chi/locator.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/detail_page_controller.dart';
import '../../controllers/notify_controller.dart';
import '../../widgets/action_button.dart';

class HeaderActionButtonGroup extends StatelessWidget {
  HeaderActionButtonGroup({
    super.key,
  });

  final pageController = Get.find<DetailPageController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          HeaderActionButtons(
            title: "خوب بود",
            icon: pageController.videoLiked
                ? FontAwesomeIcons.solidHeart
                : FontAwesomeIcons.heart,
            onTap: () {
              pageController.submitLike();
            },
          ),
          HeaderActionButtons(
            title: "ذخیره",
            icon: pageController.videoBookMarked
                ? FontAwesomeIcons.solidBookmark
                : FontAwesomeIcons.bookmark,
            onTap: () {
              pageController.submitBookmark();
            },
          ),
          HeaderActionButtons(
            title: "اشتراک گذاری",
            icon: Icons.share,
            onTap: () {
              Share.share("${pageController.videoDetail?.title} \n"
                  'https://www.cinimo.ir/video/${pageController.videoDetail?.tag} '
                  "  \n\n دانلود اپلیکیشن مووی چی! از لینک زیر \n https://www.cinimo.ir/");
            },
          ),
          HeaderActionButtons(
            title: "گزارش خطا",
            icon: Icons.bug_report_outlined,
            onTap: () {
              VideoReporter(
                      title: pageController.videoDetail!.title!,
                      tag: pageController.videoDetail!.tag!)
                  .videoReportBug(context);
            },
          ),
          if (pageController.videoDetail?.status == "not-released" ||
              pageController.videoDetail?.status == 'screening')
            GetBuilder<NotifyController>(
                init: NotifyController(
                    pageController.videoDetail?.tag ?? "", locator()),
                builder: (notifController) {
                  return HeaderActionButtons(
                    title: notifController.notify == false
                        ? "از آخرین اطلاع رسانی ها باخبرم کن"
                        : "خبردار شدم",
                    icon: notifController.notify == false
                        ? Icons.notification_add
                        : Icons.notifications_active,
                    onTap: () {
                      notifController.notifyChanger();
                    },
                  );
                }),
        ],
      ),
    );
  }
}
