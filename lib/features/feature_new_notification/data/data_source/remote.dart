import 'package:dio/dio.dart';

class NewsApiProvider {
  final Dio _dio = Dio();

  getMessages() async {
    Response response = await _dio.get(
        'https://raw.githubusercontent.com/mosbahsofttechnology/cinimo/main/notification.json');
    return response;
  }
}
