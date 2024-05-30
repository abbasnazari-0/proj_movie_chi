import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../../../core/utils/constants.dart';

// ignore: must_be_immutable
class ImageSlider extends StatelessWidget {
  ImageSlider({
    Key? key,
    // ignore: non_constant_identifier_names
    required this.item_data,
  }) : super(key: key);

  // ignore: non_constant_identifier_names
  List item_data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: ImageSlideshow(
          initialPage: 0,
          indicatorColor: Colors.blue,
          indicatorBackgroundColor: Colors.grey,
          autoPlayInterval: 5000,
          isLoop: true,
          children: [
            for (var i = 0; i < item_data.length; i++)
              GestureDetector(
                onTap: () {
                  // Get.to(() => DetailPage(
                  //       map_data: item_data[i],
                  //     ));
                  Constants.openVideoDetail(
                      vidTag: item_data[i]['tag'].toString(),
                      type: item_data[i]['type'],
                      commonTag: item_data[i]['commonTag'],
                      picture: item_data[i]['pic']);
                },
                child: CachedNetworkImage(
                  imageUrl: item_data[i]['pic'],
                  fit: BoxFit.cover,
                  httpHeaders: const {'Referer': 'https://www.cinimo.ir/'},
                  // handle error
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
