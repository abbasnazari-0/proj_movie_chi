import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_chi/core/params/check_device_status.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_login_screen/data/data_source/data_source.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/otp_phone_model.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/request_device_model.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_model.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_params.dart';
import 'package:movie_chi/features/feature_login_screen/domain/repositories/otp_repository.dart';

class OTPRepsitoryImpl extends OTPRepository {
  AuthService authService;
  OTPRepsitoryImpl(
    this.authService,
  );

  @override
  Future<DataState<OTPModel>> sendCode(String phoneNumber) async {
    var res = await authService.sendCode(phoneNumber);
    if (res.statusCode == 200) {
      OTPModel otpModel = OTPModel.fromJson(jsonDecode(res.data));

      if (otpModel.status != "error") {
        return DataSuccess(otpModel);
      } else {
        return DataFailed(otpModel.message);
      }
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<OTPModel>> validateCode(
      String code, String phoneNumber) async {
    var res = await authService.validateCode(phoneNumber, code);
    if (res.statusCode == 200) {
      OTPModel otpModel = OTPModel.fromJson(jsonDecode(res.data));

      if (otpModel.status != "error") {
        return DataSuccess(otpModel);
      } else {
        return DataFailed(otpModel.message);
      }
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<UserLoginModel>> loginUser(
      UserLoginParams loginParams) async {
    try {
      var res = await authService.loginUser(loginParams);
      debugPrint("loginUser: ${res.data}");
      if (res.statusCode == 200) {
        UserLoginModel userLoginModel =
            UserLoginModel.fromJson(jsonDecode(res.data));
        return DataSuccess(userLoginModel);
      } else {
        return DataFailed(res.statusMessage);
      }
    } catch (E) {
      return DataFailed("خطا در اینرنت ");
    }
  }

  @override
  Future<DataState<RequestDeviceModel>> requestNewDevice(
      String loginParams) async {
    try {
      var res = await authService.requestNewDevice(loginParams);
      if (res.statusCode == 200) {
        print(res.data);
        RequestDeviceModel requestDeviceModel =
            RequestDeviceModel.fromJson(jsonDecode(res.data));
        return DataSuccess(requestDeviceModel);
      } else {
        return DataFailed(res.statusMessage);
      }
    } catch (e) {
      return DataFailed("خطا در اینرنت ");
    }
  }

  @override
  Future<DataState<RequestDeviceModel>> checkDeviceStatus(
      CheckDeviceStatusParams checkDeviceStatus) async {
    try {
      var res = await authService.checkDeviceStatus(checkDeviceStatus);

      if (res.statusCode == 200) {
        RequestDeviceModel requestDeviceModel =
            RequestDeviceModel.fromJson(jsonDecode(res.data));
        return DataSuccess(requestDeviceModel);
      } else {
        return DataFailed(res.statusMessage);
      }
    } catch (e) {
      return DataFailed("خطا در اینرنت ");
    }
  }

  @override
  Future<DataState<RequestDeviceModel>> submitDeviceStatus(
      CheckDeviceStatusParams checkDeviceStatus) async {
    try {
      var res = await authService.submitDeviceStatus(checkDeviceStatus);

      if (res.statusCode == 200) {
        RequestDeviceModel requestDeviceModel =
            RequestDeviceModel.fromJson(jsonDecode(res.data));
        return DataSuccess(requestDeviceModel);
      } else {
        return DataFailed(res.statusMessage);
      }
    } catch (e) {
      return DataFailed("خطا در اینرنت ");
    }
  }
}
