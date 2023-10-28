import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerContent extends StatelessWidget {
  const HomeShimmerContent({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).primaryColor.withAlpha(200),
      highlightColor: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: CarouselSlider(
                items: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.red,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.red,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.red,
                    ),
                  ),
                ],
                options: CarouselOptions(
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    autoPlay: true,
                    enlargeCenterPage: true,
                    // viewportFraction: 0.9,
                    // disableCenter: false,
                    aspectRatio: 1,
                    autoPlayAnimationDuration: const Duration(seconds: 2)
                    // initialPage: 2,
                    ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Row(
              children: [
                SizedBox(
                  width: width * 0.05,
                ),
                Container(
                  height: 30.0,
                  width: 30,
                  color: Colors.red,
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Container(
                  height: 30.0,
                  width: 30,
                  color: Colors.red,
                ),
                const Spacer(),
                Container(
                  height: 30.0,
                  width: width * 0.5,
                  color: Colors.red,
                ),
                SizedBox(
                  width: width * 0.05,
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: height * 0.50,
              width: width,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    height: 120,
                    width: width / 2,
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.red,
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
