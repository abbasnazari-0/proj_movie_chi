// ignore_for_file: unnecessary_null_comparison

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_chi/core/params/profile_updator.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';

class ProfileApiProvider {
  Dio dio = Dio();

  Future<Response> getProfile() async {
    var baseUrl = dotenv.env['CONST_URL'];
    return await dio
        .get("$baseUrl/v9/cinimo/user_managing.php", queryParameters: {
      "type": "get_profile",
      "user_token": GetStorageData.getData("user_tag") ?? "",
    });
  }

  Future<Response> updateProfile(ProfileUpdator params) async {
    var baseUrl = dotenv.env['CONST_URL'];
    return await dio.post(
      "$baseUrl/v9/cinimo/user_managing.php",
      queryParameters: {
        'type': 'update_profile',
        'first_name': params.firstName,
        'last_name': params.lastName,
        'user_auth': params.userAuth,
        'user_token': params.userToken,
        'with_profile_pic': params.image != null ? '1' : '0',
      },
      data: params.image != null
          ? FormData.fromMap(params.image != null
              ? {
                  'pic': await MultipartFile.fromFile(params.image!.path),
                }
              : {})
          : null,
    );
  }
}
