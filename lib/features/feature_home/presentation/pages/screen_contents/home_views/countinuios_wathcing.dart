import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/widgets/mytext.dart';
import '../../../../data/model/home_catagory_model.dart';
import '../../../controller/home_page_controller.dart';

class CountinuisWatching extends StatelessWidget {
  CountinuisWatching({
    super.key,
    required this.homeCatagoryItem,
  });

  final HomeCatagoryItemModel homeCatagoryItem;
  final controller = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      bool isPortrait = constraints.maxWidth < constraints.maxHeight;
      return Container(
        color: Constants.hexToColor(homeCatagoryItem.viewColor!)
            .withAlpha(int.parse(homeCatagoryItem.colorAlpha ?? "255")),
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MyText(
                    txt: homeCatagoryItem.title!,
                    color: Theme.of(context).primaryTextTheme.bodyMedium!.color,
                    fontWeight: FontWeight.bold,
                    size: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const Gap(20),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: controller.historyList.length > 10
                      ? 10
                      : controller.historyList.length,
                  itemBuilder: (context, index) {
                    List playView =
                        (json.decode(controller.historyList[index]['data']));
                    Map item = playView[playView.length - 1];
                    double val = (double.parse(item['vid_time'].toString()) /
                        double.parse(item['vid_duration'].toString()));

                    if (val.isInfinite) val = 0;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SizedBox(
                        width: isPortrait ? width * 0.4 : width * 0.3,
                        height: 300,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Map<String, dynamic> videoDetail = json.decode(
                                    controller.historyList[index]
                                            ['video_detail']
                                        .toString());

                                if (videoDetail['type'] == "session") {
                                  Constants.openVideoDetail(
                                    vidTag: (videoDetail['common_tag'] ?? "") +
                                        '_session',
                                    type: videoDetail['type'],
                                    commonTag: videoDetail['common_tag'],
                                    picture: videoDetail['thumbnail_1x'],
                                    hero: 'countinuis_watching-${item['tag']}',
                                  );
                                } else {
                                  Constants.openVideoDetail(
                                    vidTag: (videoDetail['tag'] ?? ""),
                                    type: videoDetail['type'],
                                    commonTag: videoDetail['common_tag'],
                                    picture: videoDetail['thumbnail_1x'],
                                    hero: 'countinuis_watching-${item['tag']}',
                                  );
                                }
                              },
                              child: Hero(
                                tag: 'countinuis_watching-${item['tag']}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: isPortrait ? 200 : 150,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                Constants.imageFiller(
                                                    item['image'])),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.black87),
                                          child: const Icon(Icons.play_arrow),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.black87),
                                            margin: const EdgeInsets.all(3),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: MyText(
                                                  txt:
                                                      ' ${Constants.formatTime(item['vid_duration'])}  /  ${Constants.formatTime(item['vid_time'])}  ',
                                                  textAlign: TextAlign.center,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  size: 16),
                                            ),
                                          ),
                                        ),
                                        const Gap(10),
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: LinearProgressIndicator(
                                            value: val,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                            MyText(
                              txt: item['title'],
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyMedium!
                                  .color
                                  ?.withAlpha(200),
                              fontWeight: FontWeight.bold,
                              size: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // SizedBox(height: 10.h),
            ],
          ),
        ),
      );
    });
  }
}
