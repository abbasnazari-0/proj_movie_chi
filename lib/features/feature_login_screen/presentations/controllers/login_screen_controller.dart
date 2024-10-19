import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/params/check_device_status.dart';
import 'package:movie_chi/core/params/sign_in_profile_screen.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/request_device_model.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_model.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_sign_in_profile.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/otp_phone_model.dart';

import 'package:movie_chi/features/feature_login_screen/domain/usecase/otp_usecase.dart';

class LoginScreenController extends GetxController {
  OTPUseCase authService;

  int pageNumber = 0;
  String logTitle = "";
  LoginScreenController({
    required this.authService,
  });

  PageStatus otpSenderOTP = PageStatus.empty;

// send code
  Future<void> sendCode(TextEditingController pageController) async {
    String phoneNumber;
    otpSenderOTP = PageStatus.loading;
    update();
    phoneNumber = pageController.text;
    if (phoneNumber.isValidIranianMobileNumber()) {
      DataState dataState = await authService.sendCode(phoneNumber);
      if (dataState is DataSuccess) {
        pageNumber = 1;
        otpSenderOTP = PageStatus.success;
        update();
      }

      if (dataState is DataFailed) {
        if (dataState.error!.contains("Error sending code")) {
          logError("خطا در ارسال کد");
        } else if (dataState.error!
            .contains("You have reached maximum attempts")) {
          logError(
              "شما به حد اکثریت ارسال پیام رسیدید؛ لطفا ${extractNumber(dataState.error)} ثانیه دیگر تلاش نمایید");
        } else if (dataState.error!.startsWith("Please wait")) {
          logError("لطفا  ${extractNumber(dataState.error)} صبر کنید");
        }
        otpSenderOTP = PageStatus.error;

        update();
      }
    } else {
      logError("شماره همراه را صحیح وارد کنید");
    }
  }

  verifyOTPCode(String code, String phone) async {
    if (code.length < 5) {
      logError("کد وارد شده صحیح نمیباشد");
      update();
      return;
    }
    otpSenderOTP = PageStatus.loading;
    update();
    DataState dataState = await authService.validateCode(code, phone);

    if (dataState is DataSuccess) {
      OTPModel otpModel = dataState.data;
      if (otpModel.message!.contains("Code verified successfully")) {
        Get.off(() => const SignInProfileScreen(),
            arguments: SignInParams(phone, "", "", "", null, "", "", false));
      }
      otpSenderOTP = PageStatus.success;
    }
    if (dataState is DataFailed) {
      if (dataState.error!.contains("Code expired.")) {
        logError("اعتبار کد ارسال شده به پایان رسیده است");
      }
      if (dataState.error!.contains("Invalid code.")) {
        logError("کد وارد شده اشتباه هست");
      }
      otpSenderOTP = PageStatus.error;
    }
    update();
  }

  logError(String text) async {
    logTitle = text;
    update();

    await Future.delayed(const Duration(seconds: 3));

    logTitle = "";
    update();
  }

  extractNumber(text) {
    final intRegex = RegExp(r'\s+(\d+)\s+', multiLine: true);
    return (intRegex.allMatches(text).map((m) => m.group(0)));
  }

  PageStatus requestinNewDevice = PageStatus.empty;
  RequestDeviceModel requestDeviceModel = RequestDeviceModel();

  requestNewDevice(String userTag) async {
    requestinNewDevice = PageStatus.loading;
    update(['tablet']);

    DataState dataState = await authService.requestNewDevice(userTag);
    if (dataState is DataSuccess) {
      requestinNewDevice = PageStatus.success;
      requestDeviceModel = dataState.data;

      checking5Second = true;
      checkEvery5Second();
    }
    if (dataState is DataFailed) {
      requestinNewDevice = PageStatus.error;
    }

    update(['tablet']);
    return null;
  }

  bool checking5Second = false;
  checkEvery5Second() {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (checking5Second == false) {
        // return;
      } else {
        DataState dataState = await authService.checkDeviceStatus(
            CheckDeviceStatusParams(
                userTag: GetStorageData.getData('user_tag'),
                token: requestDeviceModel.data?.token ?? "",
                tokenID: requestDeviceModel.data?.tokenId ?? ""));
        if (dataState is DataSuccess) {
          RequestDeviceModel requestDeviceModel = dataState.data;
          if (requestDeviceModel.data?.status == "logined") {
            UserLoginModel model =
                (requestDeviceModel.data?.userLoginModel) ?? UserLoginModel();
            GetStorageData.writeData("user_tag", model.userTag);
            GetStorageData.writeData("user_status", model.userStatus);
            GetStorageData.writeData("fullName", model.fullName);
            GetStorageData.writeData(
                "user_logined", requestDeviceModel.data?.token);
            GetStorageData.writeData("time_out_premium", model.timeOutPremium);
            GetStorageData.writeData("download_max", model.downloadMax);
            GetStorageData.writeData("user_auth", model.userAuth);
            GetStorageData.writeData("user_logined", true);

            Get.back(result: model);
            Constants.showGeneralSnackBar("با موفقیت وارد شدید", "");

            checking5Second = false;
          }
        }
      }
    });
  }
}
