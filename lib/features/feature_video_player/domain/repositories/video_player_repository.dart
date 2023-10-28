import 'dart:io';

import '../../../../core/resources/data_state.dart';
import '../../data/data_source/remote/video_data_reporter.dart';
import '../../data/model/video_subtitle_model.dart';

abstract class VideoPlayerRepositry {
  final VideoDataReporter videoDataReporter;
  VideoPlayerRepositry(this.videoDataReporter);

  Future sendPlayeReport(
      String videoTag, String reportType, List<Map> viewStatus, List vedioTag);

  Future<DataState<VideoSubtitle>> getSubtitle(String qualityID);

  Future<DataState<String>> getVideoSubtitleFromLink(String link);

  // get subtitle zip file
  Future<DataState<File>> getSubtitleZipFile(String link);
}
