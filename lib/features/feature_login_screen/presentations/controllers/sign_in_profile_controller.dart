import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:movie_chi/core/params/sign_in_profile_screen.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/random_string.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_model.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_params.dart';
import 'package:movie_chi/features/feature_login_screen/domain/usecase/otp_usecase.dart';

class SignInProfileController extends GetxController {
  late SignInParams signInParams;
  OTPUseCase authService;
  SignInProfileController({required this.authService});
  TextEditingController name = TextEditingController();
  bool singInPage = true;

  startApp() async {
    // await Future.delayed(const Duration(milliseconds: 3000), () => 42);

    // Constants.showGeneralProgressBar(backDismissable: true);
    DataState dataState = await authService.loginUser(UserLoginParams(
        name.text,
        signInParams.email,
        signInParams.userToken.toString(),
        signInParams.authCode ?? "",
        signInParams.useGoogle ? "google" : "phone_number",
        generateRandomString(20)));

    if (dataState is DataSuccess) {
      UserLoginModel model = (dataState.data);
      GetStorageData.writeData("user_tag", model.userTag);
      GetStorageData.writeData("user_status", model.userStatus);
      GetStorageData.writeData("fullName", model.fullName);
      GetStorageData.writeData("user_logined", signInParams.userToken);
      GetStorageData.writeData("time_out_premium", model.timeOutPremium);
      GetStorageData.writeData("download_max", model.downloadMax);
      GetStorageData.writeData("user_auth", signInParams.email);

      if (singInPage) {
        Get.back(result: model);
        Constants.showGeneralSnackBar("با موفقیت وارد شدید", "");
        return () {};
      } else {
        return model;
      }
    }
    if (dataState is DataFailed) {
      if (singInPage) {
        Get.back(result: UserLoginModel());
        Constants.showGeneralSnackBar("خطا در ثبت اطلاعات", "");
        return () {};
      } else {
        return UserLoginModel();
      }
    }
  }
}
