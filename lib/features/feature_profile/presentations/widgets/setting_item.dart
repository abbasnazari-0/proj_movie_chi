import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class SettingItems extends StatelessWidget {
  const SettingItems({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.color,
  });

  final IconData icon;
  final String title;
  final Color? color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          // const Gap(10),
          Container(
            decoration: BoxDecoration(
              color: color ?? Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 30,
            width: 30,
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            // padding: const EdgeInsets.all(2),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          const Gap(10),
          MyText(
            txt: title.tr,
            size: 24 / 1.618,
            fontWeight: FontWeight.bold,
            // color: Colors.black,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
