import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/widgets/mytext.dart';
import '../../../data/model/video_model.dart';

class ImdbSection extends StatelessWidget {
  const ImdbSection({super.key, required this.width, required this.vid});

  final double width;
  final Video vid;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: width * 0.05),
      const Icon(Iconsax.star1, color: Colors.amber),
      SizedBox(width: width * 0.01),
      const MyText(txt: ("امتیاز IMDb : "), color: Colors.amber),

      SizedBox(width: 4.w),
      // Catagory Section
      MyText(
          txt: double.parse(vid.imdb.toString()).toStringAsFixed(1),
          size: 22,
          fontWeight: FontWeight.bold,
          color: Colors.amber),
    ]);
  }
}
