import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/widgets/mytext.dart';
import '../controllers/detail_page_controller.dart';

class CommenItem extends StatelessWidget {
  const CommenItem({
    super.key,
    required this.width,
    required this.pageController,
    required this.index,
  });

  final double width;
  final DetailPageController pageController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Container(
                    width: 40,
                    height: 40,
                    color: Theme.of(context).primaryColor,
                    child: const Center(
                        child: Icon(Iconsax.user,
                            color: Color.fromRGBO(255, 255, 255, 1)))),
              ),
              const SizedBox(width: 10),
              MyText(
                txt: pageController.commentList[index].userTag!,
              ),
              const Spacer(),
              MyText(
                txt: timeAgo(pageController.commentList[index].time!),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                MyText(
                  txt: pageController.commentList[index].comment!,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                  // maxLine: ,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  // function that convert time to previuos time in persian
  String timeAgo(time) {
    DateTime tim = DateTime.parse(time);

    // convert time to tehra time

    DateTime now = DateTime.now();

    Duration diff = now.difference(tim);

    if (diff < const Duration(minutes: 1)) {
      return 'همین الان';
    } else if (diff < const Duration(hours: 1)) {
      int minutes = diff.inMinutes;
      return '$minutes دقیقه پیش';
    } else if (diff < const Duration(days: 1)) {
      int hours = diff.inHours;
      return '$hours ساعت پیش';
    } else {
      int days = diff.inDays;
      return '$days روز پیش';
    }
  }
}
