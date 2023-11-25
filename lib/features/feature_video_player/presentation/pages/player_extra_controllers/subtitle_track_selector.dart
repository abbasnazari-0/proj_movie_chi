import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_video_player/presentation/pages/player_extra_controllers/name_helper.dart';

class SubtitleTrackHelper {
  subtitleTrackChanger(VideoController controller, SubtitleTrack audioTrack) {
    controller.player.setSubtitleTrack(audioTrack);
  }

  subtitleChooser(VideoController controller, BuildContext context,
      Function() onCustomClick) {
    // developer.log(controller.player.state.tracks.toString());
    Tracks tracks = controller.player.state.tracks;
    // developer.log(tracks.audio.toString());

    List<SubtitleTrack> subtitleTracksAvailable = [];
    for (var i = 0; i < tracks.subtitle.length; i++) {
      // developer.log(tracks.audio[i].toString());

      if (tracks.subtitle[i].id == "auto" || tracks.subtitle[i].id == "no") {
        continue;
      }
      subtitleTracksAvailable.add(tracks.subtitle[i]);
    }

    subtitleTracksAvailable.add(SubtitleTrack.no());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const MyText(
                  txt: "انتخاب زیرنویس",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                  size: 16),
              content: SizedBox(
                width: double.maxFinite,
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                          separatorBuilder: (context, index) =>
                              Divider(color: Colors.grey[50], thickness: 0.05),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subtitleTracksAvailable.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Align(
                              alignment: Alignment.center,
                              child: ListTile(
                                title: MyText(
                                  size: 12,
                                  textAlign: TextAlign.center,
                                  txt: subtitleTracksAvailable[index].id == "no"
                                      ? "غیر فعال❌"
                                      : "${subtitleTracksAvailable[index].title ?? ""} - ${NameHelper.languageDetector(subtitleTracksAvailable[index].language ?? "")}",
                                ),
                                onTap: () {
                                  subtitleTrackChanger(controller,
                                      subtitleTracksAvailable[index]);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          }),
                      const Divider(),
                      ListTile(
                        title: const MyText(
                          txt: "بیشتر",
                          size: 12,
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          onCustomClick();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
