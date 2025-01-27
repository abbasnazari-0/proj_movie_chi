import 'package:dio/dio.dart';
import 'package:movie_chi/core/params/search_params.dart';
import 'package:movie_chi/core/utils/constants.dart';

class SearchDataGetter {
  Future<Response> getData(SearchParamsQuery searchParamsQuery) async {
    Dio dio = Dio();

    var res = await dio
        .post('${Constants.baseUrl()}$pageUrl/search.php', queryParameters: {
      "page": searchParamsQuery.count,
      "query": searchParamsQuery.query,
      "type": searchParamsQuery.type,
      "zhanner": searchParamsQuery.zhanner,
      "imdb": searchParamsQuery.imdb,
      "year": searchParamsQuery.year,
      "version": await Constants.versionApplication(),
      "advancedQuery": searchParamsQuery.advancedQuery,
      // "isBouncerRequested": searchParamsQuery.isDebouncer,
    });
    return res;
  }
}
