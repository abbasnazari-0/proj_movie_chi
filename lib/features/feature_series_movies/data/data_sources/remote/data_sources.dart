import 'package:dio/dio.dart';
import 'package:movie_chi/core/utils/constants.dart';

class MoviesSeriasDataSource {
  Dio dio = Dio();

  Future<Response> getSerias(int page, String showType, String q) async {
    Response res = await dio.post(
        '${Constants.baseUrl()}${pageUrl}movies_serias.php',
        queryParameters: {
          "type": "serias",
          "page": page,
          "showType": showType,
          "q": q
        });
    return res;
  }

  Future<Response> getMovies(int page, String showType, String q) async {
    Response res = await dio.post(
        '${Constants.baseUrl()}${pageUrl}movies_serias.php',
        queryParameters: {
          "type": "movies",
          "page": page,
          "showType": showType,
          "q": q
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
