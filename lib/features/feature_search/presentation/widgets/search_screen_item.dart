import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movie_chi/core/models/search_video_model.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/mytext.dart';
import '../../../../core/widgets/video_item_header.dart';

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SearchItem extends StatelessWidget {
  const SearchItem({
    Key? key,
    required this.item,
    this.chainrouter = true,
    this.onTap,
  }) : super(key: key);
  final SearchVideo item;
  final bool chainrouter;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
        Constants.openVideoDetail(
            vidTag: item.tag.toString(),
            type: item.type,
            commonTag: item.commonTag,
            picture: item.thumbnail1x.toString());
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 20,
                    bottom: 0,
                    left: item.type != "video" ? 10 : 0,
                    right: item.type != "video" ? 10 : 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        // height: 240,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            colorBlendMode: BlendMode.srcOver,
                            color: item.type == "video"
                                ? Colors.black.withAlpha(50)
                                : Colors.black.withAlpha(190),
                            imageUrl: Constants.imageFiller(
                                item.thumbnail1x.toString()),

                            // httpHeaders: const {'Referer': 'https://www.cinimo.ir/'},
                            // handle error
                            // height: 250,
                            filterQuality: FilterQuality.low,
                            fit: BoxFit.cover,

                            // color: Colors.black.withOpacity(0.2),
                            placeholder: (context, url) => Center(
                              child: Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.black12,
                                child: Container(
                                  // height: 250,
                                  width: double.infinity,
                                  color: Colors.black26.withAlpha(20),
                                ),
                              ),
                            ),

                            // handle error
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (item.type != "video")
                    Positioned(
                      top: 8,
                      bottom: 0,
                      left: 5,
                      right: 5,
                      child: CachedNetworkImage(
                        colorBlendMode: BlendMode.srcOver,
                        color: Colors.black.withAlpha(170),
                        imageUrl:
                            Constants.imageFiller(item.thumbnail1x.toString()),

                        // httpHeaders: const {'Referer': 'https://www.cinimo.ir/'},
                        // handle error
                        height: 250,
                        filterQuality: FilterQuality.low,
                        fit: BoxFit.cover,
                        // color: Colors.black.withOpacity(0.2),
                        placeholder: (context, url) => Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: Colors.black12,
                            child: Container(
                              // height: 250,
                              width: double.infinity,
                              color: Colors.black26.withAlpha(20),
                            ),
                          ),
                        ),
                        // handle error
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  if (item.type != "video")
                    Positioned(
                      top: 22,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          colorBlendMode: BlendMode.srcOver,
                          color: Colors.black.withAlpha(50),
                          imageUrl: Constants.imageFiller(
                              item.thumbnail1x.toString()),

                          // httpHeaders: const {'Referer': 'https://www.cinimo.ir/'},
                          // handle error
                          // height: 200,
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover,
                          // color: Colors.black.withOpacity(0.2),
                          placeholder: (context, url) => Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.white,
                              highlightColor: Colors.black12,
                              child: Container(
                                // height: 250,
                                width: double.infinity,
                                color: Colors.black26.withAlpha(20),
                              ),
                            ),
                          ),

                          // handle error
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  // Positioned.fill(
                  //   child: ClipPath(
                  //     clipper: MyCustomClipper(),
                  //     child: Container(
                  //       color: Colors.red,
                  //     ),
                  //   ),
                  // ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Container(
                  //       height: 40.h,
                  //       alignment: Alignment.center,
                  //       color: Colors.black.withAlpha(150),
                  //       child: MyText(
                  //         txt: item.title.toString().replaceAll("فیلم", ""),
                  //         color: Colors.white,
                  //         maxLine: 2,
                  //         fontWeight: FontWeight.bold,
                  //         size: 16.0,
                  //         textAlign: TextAlign.center,
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Positioned(
                    // top: (item.type != "video") ? 18.h : 10.h,
                    // left: 0.w,
                    right: 0,
                    height: 25.h,
                    bottom: 0,
                    child: VideoItemHeader(
                      imdb: item.imdb.toString(),
                      isDubbed: item.dubble != null,
                      hasSubtitle: item.subtitle != null,
                    ),
                  )
                ],
              ),
            ),
            const Gap(10),
            SizedBox(
              height: 40.h,
              child: MyText(
                txt: item.title.toString().replaceAll("فیلم", ""),
                color: Colors.white,
                maxLine: 2,
                // fontWeight: FontWeight.bold,
                // size: 16.0,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ).animate(delay: 200.ms).moveY(
              begin: 0,
              end: -15,
              duration: 200.ms,
              delay: 200.ms,
            ),
      ),
    );
  }
}
