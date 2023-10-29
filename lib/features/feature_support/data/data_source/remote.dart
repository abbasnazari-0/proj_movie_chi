import 'package:dio/dio.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';

class SupportApiProvider {
  final Dio _dio = Dio();

  getMessages(int page) async {
    Response response = await _dio
        .get('${Constants.baseUrl()}$pageUrl/support.php', queryParameters: {
      "user_token": GetStorageData.getData("user_tag"),
      "type": "get",
      "page": page,
    });
    return response;
  }

  sendMessage(String message) async {
    Response response = await _dio.post(
      '${Constants.baseUrl()}$pageUrl/support.php',
      queryParameters: {
        "type": "send",
        'msg': message,
        "user_token": GetStorageData.getData("user_tag"),
        "user_noti": GetStorageData.getData("user_noti"),
        "from": "from_user",
      },
    );
    return response;
  }
}
