import 'package:dio/dio.dart';
import 'package:movie_chi/core/utils/constants.dart';

import '../../../../../core/params/play_list_params.dart';

class PlayListDataGetter {
  Dio dio = Dio();
  Future<Response> getPlayList(PlayListParams playListParams) async {
    print({
      "version": playListParams.version,
      "playlist_id": playListParams.playListId,
      "playlist_type": playListParams.playListType,
      "keyWord": playListParams.keyWord,
      "video_ids": playListParams.videoIds,
    });
    var res = await dio
        .get("${Constants.baseUrl()}${pageUrl}play_list.php", queryParameters: {
      "version": playListParams.version,
      "playlist_id": playListParams.playListId,
      "playlist_type": playListParams.playListType,
      "keyWord": playListParams.keyWord,
      "video_ids": playListParams.videoIds
    });

    return res;
  }
}
