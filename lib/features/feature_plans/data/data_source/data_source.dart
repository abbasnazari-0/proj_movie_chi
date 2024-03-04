import 'package:dio/dio.dart';
import 'package:movie_chi/core/utils/constants.dart';

class PlanApiProvider {
  final Dio _dio = Dio();

  getPlan() async {
    String appVersion = await Constants.versionApplication();
    print({"version": appVersion});
    Response res = await _dio.get("${Constants.baseUrl()}${pageUrl}plan.php",
        queryParameters: {"version": appVersion});
    return res;
  }
}
