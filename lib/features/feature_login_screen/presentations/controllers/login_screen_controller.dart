import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/params/sign_in_profile_screen.dart';
import 'package:movie_chi/core/utils/page_status.dart';
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
}
