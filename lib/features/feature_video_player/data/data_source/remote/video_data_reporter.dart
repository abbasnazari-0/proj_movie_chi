import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:path_provider/path_provider.dart';

class VideoDataReporter {
  Dio dio = Dio();

  Future<Response> sendPlayForView(
      {String reportType = "video",
      required String videoTag,
      required List<Map> viewStatus,
      required List vedioTag}) async {
    var res = await dio
        .post("${Constants.baseUrl()}${pageUrl}view.php", queryParameters: {
      "type": reportType,
      "vide_tag": videoTag,
      "user_tag": GetStorageData.getData("user_tag"),
      "view_status": jsonEncode(viewStatus),
      "vedio_tag": vedioTag.toString(),
      "version": await Constants.versionApplication(),
    });
    return res;
  }

  Future<Response> getSubtitle(String qualityID) async {
    var res = await dio
        .get("${Constants.baseUrl()}${pageUrl}subtitle.php", queryParameters: {
      "type": "get",
      "quality_id": qualityID,
    });
    return res;
  }

  Future<Response> getVideoSubtitleFromLink(String link) async {
    var res = await dio.get(link);
    return res;
  }

  Future<Response> getSubtitleZipFile(String link, String fileName) async {
    var res = await dio.download(
      link,
      '${(await getTemporaryDirectory()).path}$fileName.zip',
      options: Options(
        headers: {HttpHeaders.acceptEncodingHeader: '*'}, // Disable gzip
      ),
    );
    return res;
  }
}
