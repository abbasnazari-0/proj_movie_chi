import 'package:dio/dio.dart';

Future<String> getIpAddress() async {
  final dio = Dio();
  final response = await dio.get('https://api.ipify.org');
  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception('Failed to get IP address');
  }
}
