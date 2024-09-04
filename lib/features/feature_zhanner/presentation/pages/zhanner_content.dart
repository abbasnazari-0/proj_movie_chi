import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_zhanner/presentation/controllers/zhanner_controller.dart';
import 'package:movie_chi/features/feature_zhanner/presentation/pages/zhanner_detail.dart';
import 'package:movie_chi/locator.dart';

import '../../../../core/utils/page_status.dart';

class ZhannerList extends StatelessWidget {
  const ZhannerList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ZhannerController>(
        init: ZhannerController(locator()),
        builder: (controller) {
          // controller.getZhannerData();
          if (controller.pageStatus == PageStatus.loading) {
            return LoadingAnimationWidget.flickr(
              leftDotColor: Theme.of(context).colorScheme.secondary,
              rightDotColor:
                  Theme.of(context).colorScheme.background.withAlpha(100),
              size: 30,
            );
          }
          if (controller.pageStatus == PageStatus.error) {
            return const Center(child: Text('Error'));
          }

          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                itemCount: controller.zhannerList.length,
                itemBuilder: (context, index) {
                  String heroId = (controller.zhannerList[index].tag ?? '') +
                      UniqueKey().toString();
                  return InkWell(
                    onTap: () {
                      Get.toNamed(ZhannerDetail.routeName,
                          arguments: [controller.zhannerList[index], heroId]);
                    },
                    child: Material(
                      child: Hero(
                        tag: heroId,
                        child: Container(
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                controller.zhannerList[index].pics ?? '',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                    stops: const [0.0, 0.5],
                                    tileMode: TileMode.clamp,
                                    transform: const GradientRotation(1),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 60),
                                  child: MyText(
                                    txt: controller.zhannerList[index].tag!,
                                    color: Colors.white,
                                    size: 20,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                    maxLine: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
