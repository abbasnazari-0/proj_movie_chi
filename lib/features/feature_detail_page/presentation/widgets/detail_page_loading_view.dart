import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_chi/core/utils/constants.dart';

import '../../../../core/utils/photo_viewer_screen.dart';

class DetailPageLoadingView extends StatelessWidget {
  const DetailPageLoadingView({
    super.key,
    required this.hieght,
    required this.width,
    this.img,
  });

  final double hieght;
  final double width;
  final String? img;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hieght,
      width: width,
      child: Center(
        child: Column(
          mainAxisAlignment: (img != null)
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (img != null)
              InkWell(
                onTap: () {
                  Get.to(() =>
                      PhotoViewer(photoUrl: Constants.imageFiller(img ?? "")));
                },
                child: CachedNetworkImage(
                  imageUrl: Constants.imageFiller(img ?? ""),
                  fit: BoxFit.cover,
                  height: hieght * 0.6,
                  width: width,
                ),
              ),
            LoadingAnimationWidget.flickr(
              leftDotColor: Theme.of(context).colorScheme.secondary,
              rightDotColor:
                  Theme.of(context).colorScheme.background.withAlpha(100),
              size: width * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
