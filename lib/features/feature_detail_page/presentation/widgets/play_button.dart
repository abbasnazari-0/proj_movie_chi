import 'package:flutter/material.dart';
import 'package:movie_chi/core/utils/constants.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    Key? key,
    required this.onClick,
    this.route_name = 'null',
    required this.mapData,
  }) : super(key: key);
  final String route_name;
  final Map mapData;
  final Function(Map data) onClick;

  //Method that to run url with url_launcher

  void dialogToDownloadApplication() {
    // Get.to(() => MyVideoPlayer2(
    //       map_data: mapData,
    //     ));
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (Constants.versionApplication() == "offcial") {
      return IconButton(
          icon: const Icon(
            Icons.play_circle,
            color: Colors.white,
            size: 40.0,
          ),
          onPressed: () {});
    } else if (Constants.market_name == "google") {
      return IconButton(
          icon: const Icon(
            Icons.play_circle,
            color: Colors.white,
            size: 40.0,
          ),
          onPressed: () {
            dialogToDownloadApplication();
          });
    } else if (Constants.market_name == "bazaar" ||
        Constants.market_name == "myket") {
      return IconButton(
          icon: const Icon(
            Icons.play_circle,
            color: Colors.white,
            size: 40.0,
          ),
          onPressed: () {
            dialogToDownloadApplication();
          });
    } else {
      return Container();
    }
  }
}
