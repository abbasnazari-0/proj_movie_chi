import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../data/model/home_catagory_model.dart';

class MiniSliderView extends StatefulWidget {
  const MiniSliderView({
    super.key,
    required this.homeCatagoryItem,
  });

  final HomeCatagoryItemModel homeCatagoryItem;

  @override
  State<MiniSliderView> createState() => _MiniSliderViewState();
}

class _MiniSliderViewState extends State<MiniSliderView> {
  int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.hexToColor(widget.homeCatagoryItem.viewColor!)
          .withAlpha(int.parse(widget.homeCatagoryItem.colorAlpha ?? "255")),
      margin: const EdgeInsets.all(5),
      width: double.tryParse(widget.homeCatagoryItem.viewWidth!)!.w,
      height: double.tryParse(widget.homeCatagoryItem.viewHeight!)!.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: CarouselSlider(
            options: CarouselOptions(
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                onPageChanged: (index, _) {
                  setState(() {
                    _currentSlide = index;
                  });
                },
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3)),
            items: widget.homeCatagoryItem.data!.map((i) {
              int index = widget.homeCatagoryItem.data!.indexOf(i);
              return InkWell(
                onTap: () {
                  Constants.openHomeItem(
                      widget.homeCatagoryItem, index, i.thumbnail1x!);
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
                                      Constants.imageFiller(i.thumbnail1x!)),
                                  fit: BoxFit.cover),
                            ),
                            child: const Center(
                                // child: Text(
                                //   i.title ?? "",
                                //   style: const TextStyle(fontSize: 16.0),
                                // ),
                                )),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < widget.homeCatagoryItem.data!.length; i++)
                  Container(
                    width: 10,
                    height: 10,
                    // margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _currentSlide ? Colors.blue : Colors.grey,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
