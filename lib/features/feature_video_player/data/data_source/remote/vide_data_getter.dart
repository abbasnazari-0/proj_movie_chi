import 'package:dio/dio.dart';

import '../../../../../core/utils/constants.dart';

class DataGetter {
  Dio dio = Dio();
  //get data with http
  Future<Response> getData(uniquId) async {
    var res = await dio.post('${Constants.baseUrl()}${pageUrl}section_data.php',
        queryParameters: {
          "uniqu_id": uniquId,
          "market": Constants.market_name,
          "version": await Constants.versionApplication(),
        });
    return res;
  }
}
