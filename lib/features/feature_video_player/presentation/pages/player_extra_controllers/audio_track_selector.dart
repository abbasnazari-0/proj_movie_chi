import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

import 'name_helper.dart';

class AudioTrackHelper {
  static hasAudioTrack(VideoController controller) {
    Tracks tracks = controller.player.state.tracks;
    // developer.log(tracks.audio.toString());

    List<AudioTrack> audioTracksAvailable = [];
    for (var i = 0; i < tracks.audio.length; i++) {
      // developer.log(tracks.audio[i].toString());

      if (tracks.audio[i].id == "auto" || tracks.audio[i].id == "no") {
        continue;
      }
      audioTracksAvailable.add(tracks.audio[i]);
    }

    if (audioTracksAvailable.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static _audioTrackChanger(VideoController controller, AudioTrack audioTrack) {
    controller.player.setAudioTrack(audioTrack);
  }

  static audioChooser(VideoController controller, BuildContext context) {
    // developer.log(controller.player.state.tracks.toString());
    Tracks tracks = controller.player.state.tracks;
    // developer.log(tracks.audio.toString());

    List<AudioTrack> audioTracksAvailable = [];
    for (var i = 0; i < tracks.audio.length; i++) {
      // developer.log(tracks.audio[i].toString());

      if (tracks.audio[i].id == "auto" || tracks.audio[i].id == "no") {
        continue;
      }
      audioTracksAvailable.add(tracks.audio[i]);
    }
    audioTracksAvailable.add(AudioTrack.no());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const MyText(
                  txt: "انتخاب صدا",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                  size: 16),
              content: SizedBox(
                width: double.maxFinite,
                height: 200,
                child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey[50], thickness: 0.05),
                    itemCount: audioTracksAvailable.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: MyText(
                          size: 12,
                          textAlign: TextAlign.center,
                          txt: audioTracksAvailable[index].id == "no"
                              ? "غیر فعال ❌"
                              : "${audioTracksAvailable[index].title ?? ""} - ${NameHelper.languageDetector(audioTracksAvailable[index].language ?? "")}",
                        ),
                        onTap: () {
                          _audioTrackChanger(
                              controller, audioTracksAvailable[index]);
                          Navigator.pop(context);
                        },
                      );
                    }),
              ),
            ),
          );
        });
  }
}
