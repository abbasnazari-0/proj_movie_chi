import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeGalleryShimmer extends StatelessWidget {
  const HomeGalleryShimmer({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 200,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
