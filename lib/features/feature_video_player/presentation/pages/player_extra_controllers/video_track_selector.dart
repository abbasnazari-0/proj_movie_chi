import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'name_helper.dart';

class VideoTrackHelper {
  videoTrackChanger(VideoController controller, VideoTrack videoTrack) {
    controller.player.setVideoTrack(videoTrack);
  }

  videoTrackChooser(VideoController controller, BuildContext context) {
    // developer.log(controller.player.state.tracks.toString());
    Tracks tracks = controller.player.state.tracks;
    // developer.log(tracks.audio.toString());

    List<VideoTrack> videoTracksAvailable = [];
    for (var i = 0; i < tracks.video.length; i++) {
      // developer.log(tracks.audio[i].toString());

      if (tracks.video[i].id == "auto" ||
          tracks.video[i].id == "no" ||
          tracks.video[i].codec == "png" ||
          tracks.video[i].codec == "jpeg" ||
          tracks.video[i].codec == "jpg") {
        continue;
      }
      videoTracksAvailable.add(tracks.video[i]);
    }

    videoTracksAvailable.add(VideoTrack.no());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Video Track"),
            content: Container(
              width: double.maxFinite,
              height: 200,
              child: ListView.builder(
                  itemCount: videoTracksAvailable.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        videoTracksAvailable[index].id == "no"
                            ? "غیر فعال"
                            : "${videoTracksAvailable[index].title ?? ""} - ${NameHelper.languageDetector(videoTracksAvailable[index].language ?? "")}",
                      ),
                      onTap: () {
                        videoTrackChanger(
                            controller, videoTracksAvailable[index]);
                        Navigator.pop(context);
                      },
                    );
                  }),
            ),
          );
        });
  }
}
