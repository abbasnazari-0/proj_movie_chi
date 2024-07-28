import 'package:dio/dio.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';

class MoviesSeriasDataSource {
  Dio dio = Dio();

  Future<Response> getSerias(int page, String showType, String q) async {
    Response res = await dio
        .post('${Constants.baseUrl()}${pageUrl}home.php', queryParameters: {
      "typePage": "session",
      "page": page,
      "showType": showType,
      "q": q,
      "user_tag": GetStorageData.getData("user_tag"),
      'support_area':
          (GetStorageData.getData("logined") ?? false) ? 'true' : 'false'
    });
    return res;
  }

  Future<Response> getMovies(int page, String showType, String q) async {
    Response res = await dio
        .post('${Constants.baseUrl()}${pageUrl}home.php', queryParameters: {
      "typePage": "video",
      "page": page,
      "showType": showType,
      "q": q,
      "user_tag": GetStorageData.getData("user_tag"),
      'support_area':
          (GetStorageData.getData("logined") ?? false) ? 'true' : 'false'
    });
    return res;
  }

  Future<Response> getTypeShows() async {
    Response res = await dio.post(
        '${Constants.baseUrl()}${pageUrl}movies_serias.php',
        queryParameters: {"type": "getShowType"});
    return res;
  }
}
