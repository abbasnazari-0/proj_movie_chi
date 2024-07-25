import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:movie_chi/features/feature_artists/presentation/pages/artist_list.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/mytext.dart';
import '../../../feature_artists/data/models/artist_data_model.dart';
import '../../../feature_artists/presentation/pages/feature_artist.dart';
import '../controller/home_page_controller.dart';
import '../pages/screen_contents/home_views/grid_home_view.dart';

class ArtistHomeWidget extends StatelessWidget {
  ArtistHomeWidget({
    super.key,
  });

  final controller = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      RefreshController refreshController = RefreshController();
      return Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => const ArtistList());
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 20, top: 10, left: 10, bottom: 10),
              child: Row(
                children: [
                  MyText(
                    txt: "هنرمندان",
                    color: Theme.of(context).primaryTextTheme.bodyMedium!.color,
                    fontWeight: FontWeight.bold,
                    size: 16.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  MyText(
                      txt: "بیشتر",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      size: 13.sp),
                  const Icon(Iconsax.arrow_left_2),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 120.h,
            child: SmartRefresher(
              controller: refreshController,
              scrollDirection: Axis.horizontal,
              enablePullUp: true,
              footer: const GridLoadingEnded(),
              onLoading: () {
                controller.getArtistSuggestions(refreshController);
              },
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
                itemCount: controller.artistData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  ArtistItemData artistItemData = controller.artistData[index];
                  String uniqKey = UniqueKey().toString();
                  return InkWell(
                      onTap: () {
                        Get.to(() => ArtistPage(
                            artistItemData: artistItemData, page: uniqKey));
                      },
                      child: Hero(
                        tag: uniqKey,
                        child: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            width: 80.h,
                            // height: 120.h,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: SizedBox(
                                    width: 70.h,
                                    height: 70.h,
                                    child: CachedNetworkImage(
                                      imageUrl: Constants.imageFiller(
                                          artistItemData.artistPic ?? ""),
                                      fit: BoxFit.cover,
                                      color: Colors.black.withAlpha(80),
                                      colorBlendMode: BlendMode.darken,
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
                                      errorWidget: (context, url, error) {
                                        return const Icon(Iconsax.user);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                MyText(
                                  txt: artistItemData.artistName ?? "",
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  size: 12.sp,
                                  // maxLine: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
