import 'package:dio/dio.dart';
import 'package:movie_chi/core/utils/constants.dart';

class SearchDataGetter {
  Future<Response> getData(int itemCount, String textString) async {
    Dio dio = Dio();

    var res = await dio
        .post('${Constants.baseUrl()}${pageUrl}search.php', queryParameters: {
      "count": itemCount,
      "query": textString,
      "version": await Constants.versionApplication(),
    });
    return res;
  }
}
