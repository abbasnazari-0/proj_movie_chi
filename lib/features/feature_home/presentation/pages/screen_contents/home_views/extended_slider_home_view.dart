import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../data/model/home_catagory_model.dart';

class ExtendedSliderHomeView extends StatelessWidget {
  const ExtendedSliderHomeView({
    super.key,
    required this.homeCatagoryItem,
  });

  final HomeCatagoryItemModel homeCatagoryItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Constants.hexToColor(homeCatagoryItem.viewColor!)
            .withAlpha(int.parse(homeCatagoryItem.colorAlpha ?? "255")),
        width: double.tryParse(homeCatagoryItem.viewWidth!)!.w,
        height: double.tryParse(homeCatagoryItem.viewHeight!)!.h,
        child: CarouselSlider(
          options: CarouselOptions(
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              onPageChanged: (index, _) {
                // setState(() {
                //   _currentSlide = index;
                // });
              },
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3)),
          items: homeCatagoryItem.data!.map((i) {
            int index = homeCatagoryItem.data!.indexOf(i);
            return InkWell(
              onTap: () {
                Constants.openHomeItem(
                    homeCatagoryItem, index, i.thumbnail1x ?? "");
              },
              child: Builder(
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          // margin:
                          //     EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    Constants.imageFiller(i.thumbnail1x ?? '')),
                                fit: BoxFit.cover),
                          ),
                        )),
                  );
                },
              ),
            );
          }).toList(),
        ));
  }
}
