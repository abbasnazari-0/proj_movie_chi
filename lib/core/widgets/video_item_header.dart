import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class VideoItemHeader extends StatelessWidget {
  const VideoItemHeader({
    Key? key,
    required this.imdb,
    required this.isDubbed,
    required this.hasSubtitle,
  }) : super(key: key);

  final String imdb;
  final bool isDubbed;
  final bool hasSubtitle;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          // Icon(
          //   Iconsax.star,
          //   color: Theme.of(context).colorScheme.secondary,
          // ),
          // Expanded(
          //   child: Container(
          //     height: 25.h,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(30.h / 4),
          //       color: Theme.of(context).colorScheme.secondary,
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.black.withOpacity(1),
          //             blurRadius: 80,
          //             offset: const Offset(0, 3),
          //             spreadRadius: 10),
          //       ],
          //     ),
          //     // width: 55.w,
          //     child: Center(
          //       child: MyText(
          //         txt: "${double.parse(imdb).toStringAsFixed(1)}/10",
          //         color: Theme.of(context).colorScheme.onSecondary,
          //         size: 8.sp,
          //         fontWeight: FontWeight.bold,
          //         maxLine: 1,
          //       ),
          //     ),
          //   ),
          // ),
          // const Spacer(),
          if (hasSubtitle || isDubbed)
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: Colors.black.withAlpha(100),
                // boxShadow: [
                //   BoxShadow(
                //       color: Colors.black.withOpacity(1),
                //       blurRadius: 80,
                //       offset: const Offset(0, 3),
                //       spreadRadius: 10),
                // ],
              ),
              child: Center(
                child: Icon(
                  isDubbed
                      ? Iconsax.microphone
                      : hasSubtitle
                          ? Iconsax.subtitle
                          : null,
                  color: Colors.white,
                  fill: 0,
                  size: 12,
                ),
              ),
            ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
