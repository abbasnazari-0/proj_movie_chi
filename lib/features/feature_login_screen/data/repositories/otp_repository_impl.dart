import 'dart:convert';

import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_login_screen/data/data_source/data_source.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/otp_phone_model.dart';
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
}
