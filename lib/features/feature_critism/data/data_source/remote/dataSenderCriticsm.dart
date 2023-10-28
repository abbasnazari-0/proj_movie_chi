import 'package:dio/dio.dart';
import 'package:movie_chi/core/utils/constants.dart';

class DataSenderCritism {
  Dio dio = Dio();
  Future<Response> dataSender(critcismText) async {
    var res = dio.post('${Constants.baseUrl()}${pageUrl}criticism_reciver.php',
        queryParameters: {
          "critcism_type": 0.toString(),
          "critcism_text": critcismText.text,
          "version": await Constants.versionApplication(),
          "market": Constants.market_name,
        });
    return res;
  }
}
