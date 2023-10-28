import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movie_chi/core/utils/random_string.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/repositories/video_player_repository.dart';
import '../model/video_subtitle_model.dart';

class VideoPlayerRepositoryImpl extends VideoPlayerRepositry {
  VideoPlayerRepositoryImpl(super.videoDataReporter);

  @override
  Future sendPlayeReport(String videoTag, String reportType,
      List<Map> viewStatus, List vedioTag) async {
    return await videoDataReporter.sendPlayForView(
        videoTag: videoTag,
        reportType: reportType,
        viewStatus: viewStatus,
        vedioTag: vedioTag);
  }

  @override
  Future<DataState<VideoSubtitle>> getSubtitle(String qualityID) async {
    try {
      Response res = await videoDataReporter.getSubtitle(qualityID);
      if (res.statusCode == 200) {
        return DataSuccess(VideoSubtitle.fromJson(res.data));
      } else {
        return DataFailed("error in internet connection");
      }
    } catch (e) {
      return DataFailed("error in internet connection");
    }
  }

  @override
  Future<DataState<String>> getVideoSubtitleFromLink(String link) async {
    try {
      Response res = await videoDataReporter.getVideoSubtitleFromLink(link);
      if (res.statusCode == 200) {
        return DataSuccess((res.data));
      } else {
        return DataFailed("error in internet connection");
      }
    } catch (e) {
      return DataFailed("error in internet connection");
    }
  }

  @override
  Future<DataState<File>> getSubtitleZipFile(String link) async {
    String savePath = generateRandomString(10);
    try {
      Response res = await videoDataReporter.getSubtitleZipFile(link, savePath);
      if (res.statusCode == 200) {
        File file = File(
          '${(await getTemporaryDirectory()).path}$savePath.zip',
        );
        return DataSuccess(file);
      } else {
        return DataFailed("error in internet connection");
      }
    } catch (e) {
      return DataFailed("error in internet connection");
    }
  }
}
