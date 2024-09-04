import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_artists/presentation/controllers/artist_list_controller.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/constants.dart';
import '../../../feature_detail_page/presentation/widgets/detail_page_loading_view.dart';
import '../../../feature_home/presentation/pages/screen_contents/home_views/grid_home_view.dart';
import '../../data/models/artist_data_model.dart';
import '../widgets/artist_search_box.dart';
import 'feature_artist.dart';

class ArtistList extends StatefulWidget {
  const ArtistList({super.key});
  static const routeName = '/artist_list';

  @override
  State<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  RefreshController refreshController = RefreshController();

  final artistController = Get.find<ArtistListController>();

  @override
  void initState() {
    super.initState();
    artistController.artistPage = -1;
    artistController.artistData = [];
    artistController.getArtistSuggestions(null);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
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
          appBar: AppBar(
            toolbarHeight: 60,
            leading: const SizedBox(width: 10),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Iconsax.search_normal2))
            ],
            title: const MyText(
              txt: "هنرمندان",
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: Column(
            children: [
              ArtistSearchBox(
                searchController: artistController.searchController,
                size: size,
                onChanegd: () {
                  // if (artistController.searchController.text.isEmpty) {
                  artistController.artistPage = -1;
                  artistController.artistData = [];
                  artistController.artistName =
                      artistController.searchController.text;
                  artistController.getArtistSuggestions(null);
                  // }
                },
                onSubmited: (value) {
                  artistController.artistPage = -1;
                  artistController.artistData = [];
                  artistController.artistName = value;
                  artistController.getArtistSuggestions(null);
                },
                onClosed: () {
                  artistController.artistPage = -1;
                  artistController.artistData = [];
                  artistController.artistName = "";
                  artistController.getArtistSuggestions(null);
                },
              ),
              Expanded(
                child: GetBuilder<ArtistListController>(builder: (controller) {
                  final width = MediaQuery.of(context).size.width;
                  final hieght = MediaQuery.of(context).size.height;
                  if (controller.pageStatus == PageStatus.loading) {
                    return DetailPageLoadingView(hieght: hieght, width: width);
                  }
                  if (controller.pageStatus == PageStatus.error) {
                    return const Center(
                        child: MyText(
                      txt: "خطا در دریافت اطلاعات",
                    ));
                  }
                  if (controller.artistData.isEmpty) {
                    return const Center(
                        child: MyText(
                      txt: "اطلاعاتی یافت نشد",
                    ));
                  }
                  return SmartRefresher(
                    controller: refreshController,
                    onLoading: () {
                      controller.getArtistSuggestions(refreshController);
                    },
                    enablePullDown: false,
                    enablePullUp: true,
                    footer: const GridLoadingEnded(),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        ArtistItemData artistItemData =
                            controller.artistData[index];
                        String uniqKey = UniqueKey().toString();
                        return InkWell(
                            onTap: () {
                              Get.toNamed(ArtistPage.routeName, arguments: {
                                "artistItemData": artistItemData,
                                "page": uniqKey,
                              });
                            },
                            child: Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                width: 60,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(999),
                                      child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: Hero(
                                          tag:
                                              'artist${artistItemData.artistTag}',
                                          child: CachedNetworkImage(
                                            imageUrl: Constants.imageFiller(
                                                artistItemData.artistPic ?? ""),
                                            fit: BoxFit.cover,
                                            color: Colors.black.withAlpha(80),
                                            colorBlendMode: BlendMode.darken,
                                            placeholder: (context, url) =>
                                                Center(
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.white,
                                                highlightColor: Colors.black12,
                                                child: Container(
                                                  // height: 250,
                                                  width: double.infinity,
                                                  color: Colors.black26
                                                      .withAlpha(20),
                                                ),
                                              ),
                                            ),
                                            errorWidget: (context, url, error) {
                                              return Container(
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Iconsax.user,
                                                    color: Colors.black,
                                                  ));
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Gap(5),
                                    MyText(
                                      txt: artistItemData.artistName ?? "",
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      maxLine: 10,
                                    )
                                  ],
                                ),
                              ),
                            ));
                      },
                      itemCount: controller.artistData.length,
                    ),
                  );
                }),
              ),
            ],
          )),
    );
  }
}
