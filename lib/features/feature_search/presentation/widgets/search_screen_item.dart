import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
            hero: 'search-item-${item.tag}',
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
                    top: 15,
                    bottom: 0,
                    left: item.type != "video" ? 10 : 0,
                    right: item.type != "video" ? 10 : 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        // height: 240,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Hero(
                            tag: 'search-item-${item.tag}',
                            child: CachedNetworkImage(
                              colorBlendMode: BlendMode.srcOver,
                              color: item.type == "video"
                                  ? Colors.black.withAlpha(50)
                                  : Colors.black.withAlpha(190),
                              imageUrl: Constants.imageFiller(
                                  item.thumbnail1x.toString()),

                              filterQuality: FilterQuality.low,
                              scale: 0.1,
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
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (item.type != "video")
                    Positioned(
                      top: 20,
                      bottom: 0,
                      left: 5,
                      right: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          colorBlendMode: BlendMode.srcOver,
                          color: Colors.black.withAlpha(100),
                          imageUrl: Constants.imageFiller(
                              item.thumbnail1x.toString()),
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
                    ),
                  if (item.type != "video")
                    Positioned(
                      top: 25,
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
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 0,
                    height: 25,
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
              height: 40,
              child: MyText(
                txt: item.title.toString().replaceAll("فیلم", ""),
                color: Colors.white,
                maxLine: 2,
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
