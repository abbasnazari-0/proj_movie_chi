import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../../core/widgets/mytext.dart';
import '../../../data/model/video_model.dart';
import '../../widgets/catagory_list.dart';

class YearATags extends StatelessWidget {
  const YearATags({super.key, required this.width, required this.vid});

  final double width;
  final Video vid;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: width * 0.05),
          Icon(Icons.calendar_month_rounded,
              color: Theme.of(context).colorScheme.secondary),
          const Gap(4),
          MyText(txt: (vid.year ?? "")),
          const Gap(10),
          const Text("●", style: TextStyle(color: Colors.grey)),

          const Gap(10),
          Icon(FontAwesome.masks_theater,
              color: Theme.of(context).colorScheme.secondary),
          const Gap(4),
          // Catagory Section
          if (vid.tagData != null) catagoryWidget(vid.tagData!),
        ],
      ),
    );
  }
}
