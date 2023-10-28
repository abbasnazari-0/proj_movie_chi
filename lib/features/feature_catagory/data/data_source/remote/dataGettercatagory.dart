import 'package:dio/dio.dart';

import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/features/feature_catagory/data/data_source/remote/catagory_params.dart';

class DataGetterCatagory {
  Dio dio = Dio();

  Future<Response> getData(CatagoryParams catagoryParams) async {
    var res = await dio.post(
        '${Constants.baseUrl()}${pageUrl}catagory_data.php',
        queryParameters: {
          "data_count": catagoryParams.itemCount.toString(),
          "data_cat": catagoryParams.tag,
          "version": await Constants.versionApplication(),
          "market": Constants.market_name,
        });
    return res;
  }
}
