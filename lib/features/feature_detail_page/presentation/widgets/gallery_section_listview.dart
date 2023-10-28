import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

import '../../../../core/utils/constants.dart';
import '../controllers/detail_page_controller.dart';

class GallerySectionListView extends StatelessWidget {
  const GallerySectionListView({
    super.key,
    required this.width,
    required this.itemCount,
    required this.pageController,
  });

  final double width;
  final int itemCount;
  final DetailPageController pageController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: width,
      child: ListView.builder(
        itemCount: pageController.extendGallery
            ? pageController.galleryList.length
            : itemCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          bool islast = index == itemCount - 1;
          return GestureDetector(
            onTap: () {
              if (islast) {
                pageController.changeListViewView(true);
              }
              pageController.onGalleryTap(pageController.galleryList[index]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: Constants.imageFiller(
                          pageController.galleryList[index]),
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                      httpHeaders: const {'Referer': 'https://www.cinimo.ir/'},
                      // handle error
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  if (islast && !pageController.extendGallery)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withOpacity(0.8),
                        ),
                        width: 40,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyText(
                            txt:
                                '+${pageController.galleryList.length - itemCount + 1}',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
