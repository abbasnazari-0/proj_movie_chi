import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchShimmer extends StatelessWidget {
  const SearchShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white10,
      highlightColor: Colors.white24,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: MediaQuery.of(context).size.height * 0.25,
            crossAxisCount: 3),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                height: 250,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
