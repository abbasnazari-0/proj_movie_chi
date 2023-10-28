import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:movie_chi/core/utils/constants.dart';

class PhotoViewer extends StatelessWidget {
  const PhotoViewer({Key? key, required this.photoUrl, this.heroTag})
      : super(key: key);

  final String photoUrl;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag != null ? heroTag! : Constants.imageFiller(photoUrl),
      child: PinchZoom(
        resetDuration: const Duration(milliseconds: 100),
        maxScale: 2.5,
        onZoomStart: () {
          debugPrint('Start zooming');
        },
        onZoomEnd: () {
          debugPrint('Stop zooming');
        },
        child: CachedNetworkImage(imageUrl: photoUrl),
      ),
    );
  }
}
