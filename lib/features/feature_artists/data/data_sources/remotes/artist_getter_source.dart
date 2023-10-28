import 'package:dio/dio.dart';

import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/get_storage_data.dart';

class ArtistGetter {
  Dio dio = Dio();

  getArtistData(
      int itemCount, int page, String? artistName, String? artistTag) async {
    var res = await dio
        .get('${Constants.baseUrl()}${pageUrl}artist.php', queryParameters: {
      "type": "getArtistData",
      "version": Constants.versionApplication(),
      "mtype": "artist",
      "user_tag": GetStorageData.getData("user_tag") ?? "",
      "limit": itemCount,
      "page": page,
      "artist_name": artistName,
      "artist_tag": artistTag,
    });
    return res;
  }

  getArtistSuggestionData(
      int itemCount, int page, String? artistName, String? artistTag) {
    return dio
        .get('${Constants.baseUrl()}${pageUrl}artist.php', queryParameters: {
      "type": "get",
      "version": Constants.versionApplication(),
      "mtype": "suggestion",
      "user_tag": GetStorageData.getData("user_tag") ?? "",
      "limit": itemCount,
      "page": page,
      "name": artistName
    });
  }
}
