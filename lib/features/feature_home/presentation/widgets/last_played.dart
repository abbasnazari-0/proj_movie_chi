import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/utils/constants.dart';

import 'package:movie_chi/core/widgets/mytext.dart';
import '../../../../core/utils/database_helper.dart';
import '../../../../locator.dart';
import '../../../feature_detail_page/data/model/video_model.dart';
import '../controller/home_page_controller.dart';

class LastPlayerScreen extends StatefulWidget {
  const LastPlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LastPlayerScreen> createState() => _LastPlayerScreenState();
}

class _LastPlayerScreenState extends State<LastPlayerScreen> {
  @override
  void initState() {
    super.initState();
  }

  final homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,

          floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 30, right: 20),
            child: FloatingActionButton(
              onPressed: () {
                Get.back();
              },
              backgroundColor: Theme.of(context).colorScheme.background,
              child: Icon(Iconsax.arrow_right_14,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ),
          // appBar: AppBar(
          //   title: const MyText(txt: 'ذخیره شده'),
          // ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: GetBuilder<HomePageController>(builder: (con) {
            return homePageController.historyList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lotties/empty.json',
                            width: size.width * 0.4),
                        const Text('فیلم ذخیره شده ای ندارید'),
                      ],
                    ),
                  )
                : SizedBox(
                    width: size.width,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(10),
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.white30),
                      itemBuilder: (context, index) {
                        List playView = (json.decode(
                            homePageController.historyList[index]['data']));
                        Map item = playView[playView.length - 1];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: double.infinity,
                            height: size.width / 2 + 20,
                            child: InkWell(
                              onTap: () {
                                Video vid = Video.fromJson((json.decode(
                                    homePageController.historyList[index]
                                        ['video_detail'])));

                                // Get.to(
                                //     () => DetailPage(vid_tag: item['tag']));

                                if (vid.type == "session") {
                                  Constants.openVideoDetail(
                                    vidTag: "${vid.commonTag}_session",
                                    type: item['type'],
                                    commonTag: item['commonTag'],
                                    picture: item['image'],
                                  );
                                } else {
                                  Constants.openVideoDetail(
                                    vidTag: vid.tag ?? "",
                                    type: item['type'],
                                    commonTag: item['commonTag'],
                                    picture: item['image'],
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        Constants.imageFiller(item['image'])),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.5),
                                        BlendMode.darken),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: size.width,
                                      height: 50,
                                      color: Colors.black26,
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MyText(
                                              txt: item['title'],
                                              size: 18,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                              onPressed: () {
                                                // delete from history
                                                DictionaryDataBaseHelper
                                                    dbHelper = locator();
                                                dbHelper.query(
                                                    "DELETE FROM tbl_history WHERE tag = '${item['tag']}'");

                                                homePageController
                                                    .hasDataInLocalStorage();
                                              },
                                              icon: const Icon(
                                                Icons.delete_rounded,
                                                color: Colors.red,
                                              )),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Iconsax.export_34, size: 40),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black87),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
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
                                    LinearProgressIndicator(
                                      value: item['vid_time'] /
                                          item['vid_duration'],
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: homePageController.historyList.length,
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
