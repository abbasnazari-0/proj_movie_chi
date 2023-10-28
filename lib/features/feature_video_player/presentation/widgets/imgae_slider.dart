import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../../feature_home/data/model/home_catagory_model.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({
    Key? key,
    required this.item_data,
  }) : super(key: key);

  final HomeCatagoryItemModel item_data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: const ImageSlideshow(
            initialPage: 0,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            autoPlayInterval: 5000,
            isLoop: true,
            children: [],
          )
          //
          //   children: [
          // for (var i = 0; i < item_data.data!.length; i++)
          //   GestureDetector(
          //     onTap: () {
          //       // Get.to(() => DetailPage(
          //       //       map_data: item_data[i],
          //       //     ));
          //     },
          //     child: CachedNetworkImage(
          //       imageUrl: item_data.data![i].thumbnail1x!,
          //       fit: BoxFit.cover,
          //       httpHeaders: const {'Referer': 'https://www.cinimo.ir/'},
          //       // handle error
          //       errorWidget: (context, url, error) => const Icon(Icons.error),
          //     ),
          //   ),
          // ],
          // ),
          ),
    );
  }
}
