import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';

class HomeCatagoryMainShimmer extends StatelessWidget {
  const HomeCatagoryMainShimmer({
    super.key,
    required this.homeCatagory,
  });

  final HomeCatagory homeCatagory;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
        // shimmer color that has good color in light and dark
        baseColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).colorScheme.background,
        child: ListView.builder(
          // itemCount: homeCatagory.values?.length,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          itemBuilder: (context, index) {
            return SizedBox(
              width: 100,
              child: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(color: Colors.red),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
