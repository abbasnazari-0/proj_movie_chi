import 'package:flutter/material.dart';

import '../../../../../core/widgets/mytext.dart';
import '../../../data/model/video_model.dart';
import '../../widgets/quality_widget.dart';

class TitleAQualities extends StatelessWidget {
  const TitleAQualities({super.key, required this.width, required this.vid});

  final double width;
  final Video vid;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: width * 0.05),
          MyText(
            txt: vid.title ?? "",
            fontWeight: FontWeight.bold,
            size: 20,
          ),
          SizedBox(width: width * 0.05),
          // Qualities List
          if (vid.quality720 != null) qualityWidget('HD'),
          if (vid.quality1080 != null) qualityWidget('FHD'),
          if (vid.quality2160 != null) qualityWidget('4K'),
          if (vid.quality1440 != null) qualityWidget('2K'),
          if (vid.quality4320 != null) qualityWidget('8K'),
        ],
      ),
    );
  }
}
