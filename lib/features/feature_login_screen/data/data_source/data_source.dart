import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_chi/core/params/check_device_status.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_params.dart';
// import 'package:platform_device_id/platform_device_id.dart';

import '../../../../core/utils/constants.dart';

class AuthService {
  Dio dio = Dio();

  Future<Response> sendCode(String phoneNumber) async {
    return await dio
        .post("${Constants.baseUrl()}${pageUrl}phone.php", queryParameters: {
      "type": "submit",
      "phone": phoneNumber,
      "version": await Constants.versionApplication(),
    });
  }

  Future<Response> validateCode(String phoneNumber, String code) async {
    return await dio
        .post("${Constants.baseUrl()}${pageUrl}phone.php", queryParameters: {
      "type": "verify",
      "phone": phoneNumber,
      "code": code,
      "version": await Constants.versionApplication(),
    });
  }

  Future<Response> loginUser(UserLoginParams params) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // String? deviceId = await PlatformDeviceId.getDeviceId;

    String deviceName = "";

    if (kIsWeb) {
      deviceName = "web";
    } else {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.utsname.machine;
      }
    }
    return await dio.post(
      "${Constants.baseUrl()}${pageUrl}login.php",
      queryParameters: {
        "device_name": deviceName,
        "device_id": "",
        "user_tag": params.userTag,
        "version": await Constants.versionApplication(),
        "full_name": params.fullName,
        "user_auth": params.userAuth,
        "google_id": params.googleId,
        "google_token": params.googleToken,
        "sign_in_method": params.signInMethod,
        "prev_user_tag": GetStorageData.getData("user_tag"),
        'with_profile_pic': params.profile != null ? '1' : '0',
      },
      data: params.profile != null
          ? FormData.fromMap(params.profile != null
              ? {
                  'pic': await MultipartFile.fromFile(params.profile!.path),
                }
              : {})
          : null,
    );
  }

  requestNewDevice(String userTag) async {
    return await dio.request(
      "${Constants.baseUrl()}${pageUrl}device_login.php",
      queryParameters: {
        "type": "create",
        "user_tag": "Era5VYCSzSx1QoXS7bxq",
      },
    );
  }

  checkDeviceStatus(CheckDeviceStatusParams params) async {
    debugPrint(params.token);
    return await dio.request(
      "${Constants.baseUrl()}${pageUrl}device_login.php",
      queryParameters: {
        "type": "check",
        "user_tag": params.userTag,
        "token_id": params.tokenID,
        "token": params.token,
      },
    );
  }

  submitDeviceStatus(CheckDeviceStatusParams params) async {
    return await dio.request(
      "${Constants.baseUrl()}${pageUrl}device_login.php",
      queryParameters: {
        "type": "submit",
        "user_tag": params.userTag,
        "token_id": params.tokenID,
        "token": params.token,
      },
    );
  }
}
