import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:movie_chi/core/utils/page_status.dart';

import '../../../../core/models/search_video_model.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/photo_viewer_screen.dart';
import '../../../../core/widgets/mytext.dart';
import '../../../feature_detail_page/presentation/widgets/detail_page_loading_view.dart';
import '../../../feature_search/presentation/widgets/search_screen_item.dart';
import '../../data/models/artist_data_model.dart';
import '../controllers/artist_list_controller.dart';

// ignore: must_be_immutable
class ArtistPage extends StatefulWidget {
  ArtistPage({
    Key? key,
  }) : super(key: key);
  String page = Get.arguments['page'];
  ArtistItemData artistItemData = Get.arguments['artistItemData'];

  static const routeName = '/artist';

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  RefreshController refreshController = RefreshController();
  final artistController = Get.find<ArtistListController>();
  @override
  void initState() {
    super.initState();
    artistController.artistVideoPage = -1;
    artistController.artistVideoData = [];
    artistController.getArtistData(null, widget.artistItemData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
        body: SafeArea(
            child: NestedScrollView(
          body: GetBuilder<ArtistListController>(builder: (artistController) {
            final width = MediaQuery.of(context).size.width;
            final hieght = MediaQuery.of(context).size.height;
            if (artistController.pageStatus2 == PageStatus.loading) {
              return DetailPageLoadingView(hieght: hieght, width: width);
            }
            if (artistController.pageStatus2 == PageStatus.error) {
              return const Center(
                  child: MyText(
                txt: "خطا در دریافت اطلاعات",
              ));
            }
            if (artistController.artistVideoData.isEmpty) {
              return const Center(
                  child: MyText(
                txt: "اطلاعاتی یافت نشد",
              ));
            }
            return Directionality(
              textDirection: TextDirection.rtl,
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 20),
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: MediaQuery.of(context).size.height * 0.25,
                    crossAxisCount: 3),
                itemCount: artistController.artistVideoData.length,
                itemBuilder: (BuildContext context, int index) {
                  // SearchVideo item = controller.playListModel!.data![index];
                  SearchVideo itemVideo =
                      artistController.artistVideoData[index];

                  return SearchItem(item: itemVideo, chainrouter: true);
                  // return Container();
                },
              ),
            );
          }),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 600,
              pinned: true,
              title: MyText(
                txt: widget.artistItemData.artistName ?? "",
                color: Colors.white,
                fontWeight: FontWeight.bold,
                size: 20,
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: true,
              titleSpacing: 0,
              leading: const SizedBox(),
              flexibleSpace: FlexibleSpaceBar(
                background: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: 80,
                    child: SizedBox(
                      width: 60,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(PhotoViewer.routeName, arguments: {
                            'photoUrl': Constants.imageFiller(
                                widget.artistItemData.artistPic ?? ""),
                            'tag': widget.page
                          });
                        },
                        child: Hero(
                          tag: 'artist${widget.artistItemData.artistTag}',
                          child: CachedNetworkImage(
                            imageUrl: Constants.imageFiller(
                                widget.artistItemData.artistPic ?? ""),
                            fit: BoxFit.cover,
                            color: Colors.black.withAlpha(100),
                            colorBlendMode: BlendMode.darken,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}
