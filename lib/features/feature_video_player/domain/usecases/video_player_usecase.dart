import 'dart:io';

import '../../../../core/resources/data_state.dart';
import '../../data/model/video_subtitle_model.dart';
import '../repositories/video_player_repository.dart';

class VideoPlayerUseCase {
  final VideoPlayerRepositry videoPlayerRepositry;

  VideoPlayerUseCase(this.videoPlayerRepositry);

  Future playVideoReport(String videoTag, String videoReportType,
      List<Map> viewStatus, List vedioTag) async {
    return await videoPlayerRepositry.sendPlayeReport(
        videoTag, videoReportType, viewStatus, vedioTag);
  }

  Future<DataState<VideoSubtitle>> getSubtitle(String qualityID) async {
    return await videoPlayerRepositry.getSubtitle(qualityID);
  }

  Future<DataState<String>> getVideoSubtitleFromLink(String link) async {
    return await videoPlayerRepositry.getVideoSubtitleFromLink(link);
  }

  Future<DataState<File>> getSubtitleZipFile(String link) async {
    return await videoPlayerRepositry.getSubtitleZipFile(link);
  }
}
