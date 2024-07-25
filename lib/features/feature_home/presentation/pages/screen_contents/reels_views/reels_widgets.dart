import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/widgets/mytext.dart';
import '../../../../data/model/home_reels_model.dart';
import '../../../controller/home_page_controller.dart';
import '../../../widgets/reels_comment_bottom_sheet.dart';

// ignore: must_be_immutable
class ReelsControllerWidgets extends StatelessWidget {
  ReelsControllerWidgets({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;
  final controller = Get.find<HomePageController>();
  bool supportedArea = ((GetStorageData.getData("logined") ?? false));
  @override
  Widget build(BuildContext context) {
    final ReelsModel reelsModel = controller.reelsData[index];
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: size.height * 0.01),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.white.withAlpha(80),
                ),
                height: 40,
                width: 40,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Iconsax.messages_24, size: 16),
                    onPressed: () {
                      controller.loadReelsComment(reelsModel);
                      CommentBottomSheet(size, context, reelsModel);
                    },
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              if (supportedArea)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Colors.white.withAlpha(80),
                  ),
                  height: 40,
                  width: 40,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Iconsax.video_play4, size: 16),
                      onPressed: () {
                        Constants.openVideoDetail(
                            vidTag: controller.reelsData[index].videoTags
                                .toString(),
                            picture: "");
                      },
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: MyText(
              txt: controller.reelsData[index].caption!,
              color: Colors.white,
              size: 20,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.right,
              maxLine: 5,
            ),
          ),
        ],
      ),
    );
  }
}
