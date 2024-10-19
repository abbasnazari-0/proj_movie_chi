import 'package:flutter/material.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/widgets/quality_chooser.dart';

class CheckQuality {
  static Future<String> checkQuality(Video video,
      {String? actionButton, bool? justQuality}) async {
    // if just have 1 quality
    List<Map<String, String?>> videosQualities = [
      {"vid": video.quality1080, "quality": "1080"},
      {"vid": video.quality1440, "quality": "1440"},
      {"vid": video.quality2160, "quality": "2160"},
      {"vid": video.quality360, "quality": "360"},
      {"vid": video.quality480, "quality": "480"},
      {"vid": video.quality720, "quality": "720"},
      {"vid": video.quality240, "quality": "240"},
      {"vid": video.quality4320, "quality": "4320"}
    ];

    // if not have any quality
    if (videosQualities.where((element) => element["vid"] != null).isEmpty) {
      // show error
      Constants.showGeneralSnackBar(
          "خطا", "کیفیتی برای ${actionButton ?? ""} وجود ندارد");
      return "";
    }
    // where to check
    if (videosQualities.where((element) => element["vid"] != null).length ==
        1) {
      // download video
      // return one quality
      debugPrint(justQuality.toString());

      // if ((justQuality ?? false) == true) {
      return videosQualities
          .where((element) => element["vid"] != null)
          .first["vid"]!;
      // }
    } else {
      String qualitySelected = "";
      // debugPrint(videosQualities.toString());
      // debugPrint(justQuality.toString());
      // show dialog to choose quality
      qualitySelected = await chooseQuality(videosQualities,
          actionButton: actionButton, justQuality: justQuality);
      debugPrint(qualitySelected.toString());
      return (qualitySelected);
    }
  }
}
