import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:movie_chi/features/feature_home/presentation/pages/screen_contents/download_views/downloading_view.dart';

import '../../../../../core/utils/database_helper.dart';
import '../../../../../locator.dart';
import '../../../../feature_detail_page/presentation/controllers/detail_page_controller.dart';
import 'download_views/downloaded_view.dart';
import 'download_views/empty_download_view.dart';

class DownloadContent extends StatefulWidget {
  const DownloadContent({super.key});
  @override
  State<DownloadContent> createState() => _DownloadContentState();
}

class _DownloadContentState extends State<DownloadContent> {
  final pageController = Get.find<DetailPageController>();
  DictionaryDataBaseHelper dbHelper = locator();
  // create function to check file exist
  Future<bool> checkFileExists(String filePath) async {
    File file = File(filePath);
    return await file.exists();
  }

  // remove unfound file from list
  removeUnfoundFile(List list) async {
    for (var item in list) {
      if (item['download_status'] == "true") {
        String? filePath = (item['download_path']);

        if (!await checkFileExists(filePath ?? '')) {
          await dbHelper.query(
              "DELETE FROM tbl_downloaded WHERE `tag` = '${item['tag']}' ");
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailPageController>(
        didChangeDependencies: (state) {},
        initState: (state) async {
          await pageController.updateList();
        },
        builder: (controller) {
          // updateList();
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: pageController.homeVideoDownloaded.isNotEmpty ||
                    pageController.isDownloading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pageController.isDownloading) DownloadingView(),
                        if (pageController.homeVideoDownloaded.isNotEmpty)
                          DownloadedView(
                              videoDownloadedList:
                                  pageController.homeVideoDownloaded)
                      ],
                    ),
                  )
                : const EmptyDownloadPage(),
          );
        });
  }
}
