import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_chi/core/params/sign_in_profile_screen.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/choose_image_source.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/utils/random_string.dart';
import 'package:movie_chi/core/utils/utils.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_model.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_params.dart';
import 'package:movie_chi/features/feature_login_screen/domain/usecase/otp_usecase.dart';

import '../../../../locator.dart';
import '../../../feature_profile/data/models/profile_model.dart';
import '../../../feature_profile/domain/usecases/profile_usecase.dart';

class SignInProfileController extends GetxController {
  late SignInParams signInParams;
  OTPUseCase authService;
  SignInProfileController({required this.authService});
  TextEditingController name = TextEditingController();
  TextEditingController fName = TextEditingController();

  bool singInPage = true;

  final ProfileUsecase _profileUsecase = locator();

  @override
  onInit() {
    super.onInit();
    getProfileData();
  }

  PageStatus pageStatus = PageStatus.success;
  getProfileData() async {
    pageStatus = PageStatus.loading;
    update();
    SignInParams signInParamss = Get.arguments;

    DataState dataState =
        await _profileUsecase.getProfile(userAuth: signInParamss.email);

    if (dataState is DataSuccess) {
      ProfileModel profileModel = dataState.data;
      name.text = profileModel.data?.first.fullName ?? "";
      fName.text = profileModel.data?.first.lastName ?? "";
      // phoneController.text = profileModel.data?.first.userAuth ?? "";
      pathImage = profileModel.data?.first.pic ?? "";
      // debugPrint(profileModel.data?.first.toJson().toString());
      pageStatus = PageStatus.success;
    }

    if (dataState is DataFailed) {
      Get.snackbar('Error', dataState.error ?? "");
      pageStatus = PageStatus.error;
    }
    update();
  }

  chooseImage() async {
    String? result = await ImageSourceChooser.chooseImageSource();

    if (result == null) {
      return;
    }

    final ImagePicker picker = ImagePicker();

    XFile? img = await picker.pickImage(
      source: result == 'camera' ? ImageSource.camera : ImageSource.gallery,
    );
    if (img == null) {
      return;
    }
    XFile? compresses = await Utils().testCompressAndGetFile(img);

    if (compresses != null) {
      // pickerFile = compresses;
      // productController.webImage = pickerFile!.path;
      pickerFile = compresses;
      // productController.webImage = pickerFile!.path;
      hasImage = true;
    }

    update();
  }

  bool hasImage = false;
  String pathImage = "";
  XFile? pickerFile;
  PageStatus registerProfile = PageStatus.empty;
  startApp() async {
    // if (registerProfile == PageStatus.loading) {
    //   registerProfile = PageStatus.success;
    //   update();
    //   return;
    // }
    if (name.text == "") {
      Constants.showGeneralSnackBar("نام", "لطفا نام خود را وارد کنید");
      return;
    }
    // await Future.delayed(const Duration(milliseconds: 3000), () => 42);

    registerProfile = PageStatus.loading;
    update();

    var messaging = FirebaseMessaging.instance;
    var token = await messaging.getToken();
    // GetStorageData.writeData("user_noti", token);
    DataState dataState = await authService.loginUser(UserLoginParams(
      name.text,
      signInParams.email,
      signInParams.userToken.toString(),
      signInParams.authCode ?? "",
      signInParams.useGoogle ? "google" : "phone_number",
      generateRandomString(20),
      profile: pickerFile,
      userNotifToken: token,
    ));

    if (dataState is DataSuccess) {
      UserLoginModel model = (dataState.data);
      GetStorageData.writeData("user_tag", model.userTag);
      GetStorageData.writeData("user_status", model.userStatus);
      GetStorageData.writeData("fullName", model.fullName);
      GetStorageData.writeData("user_logined", signInParams.userToken);
      GetStorageData.writeData("time_out_premium", model.timeOutPremium);
      GetStorageData.writeData("download_max", model.downloadMax);
      GetStorageData.writeData("user_auth", signInParams.email);
      GetStorageData.writeData("user_logined", true);

      ProfileModel profileModel = ProfileModel(data: [
        ProfileModelData(
          fullName: name.text,
          lastName: fName.text,
          userAuth: signInParams.email,
          pic: model.profile,
          signInMethod: signInParams.useGoogle ? "google" : "phone_number",
        )
      ]);

      GetStorageData.writeData(
          "user_profile", profileModel.data?.first.toJson());
      registerProfile = PageStatus.success;
      update();

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
