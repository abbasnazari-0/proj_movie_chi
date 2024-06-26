import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_chi/core/params/profile_updator.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/choose_image_source.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/my_snack_bar.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/utils/utils.dart';
import 'package:movie_chi/features/feature_profile/data/models/profile_model.dart';
import 'package:movie_chi/features/feature_profile/domain/usecases/profile_usecase.dart';

class EditProfileController extends GetxController {
  final ProfileUsecase profileUsecase;
  TextEditingController nameController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool hasImage = false;
  String pathImage = "";
  XFile? pickerFile;
  PageStatus pageStatus = PageStatus.loading;
  PageStatus updatePageStatus = PageStatus.empty;

  EditProfileController(this.profileUsecase);

  @override
  onInit() {
    super.onInit();
    getProfileData();
  }

  getProfileData() async {
    pageStatus = PageStatus.loading;
    update();
    DataState dataState = await profileUsecase.getProfile();
    if (dataState is DataSuccess) {
      ProfileModel profileModel = dataState.data;
      nameController.text = profileModel.data?.first.fullName ?? "";
      familyController.text = profileModel.data?.first.lastName ?? "";
      phoneController.text = profileModel.data?.first.userAuth ?? "";
      pathImage = profileModel.data?.first.pic ?? "";
      print(profileModel.data?.first.toJson());
      pageStatus = PageStatus.success;
    }

    if (dataState is DataFailed) {
      Get.snackbar('Error', dataState.error ?? "");
      pageStatus = PageStatus.error;
    }
    update();
  }

  updateProfile() async {
    if (nameController.text.isEmpty) {
      MySnackBar.showSnackBar(Get.context!, "Name is required",
          title: "Error", mode: AlertMode.error);
      return;
    }

    if (familyController.text.isEmpty) {
      // Get.snackbar('Error', 'Family is required');
      MySnackBar.showSnackBar(Get.context!, "Family is required",
          title: "Error", mode: AlertMode.error);
      return;
    }

    if (phoneController.text.isEmpty) {
      MySnackBar.showSnackBar(Get.context!, "Phone is required",
          title: "Error", mode: AlertMode.error);
      return;
    }

    ProfileUpdator profileModel = ProfileUpdator(
      firstName: nameController.text,
      lastName: familyController.text,
      userAuth: phoneController.text,
      image: pickerFile,
      userToken: GetStorageData.getData("user_tag") ?? "",
    );

    // print(profileModel.toJson());
    // return;
    updatePageStatus = PageStatus.loading;
    update();
    DataState dataState = await profileUsecase.updateProfile(profileModel);

    if (dataState is DataSuccess) {
      ProfileModel profileModel = dataState.data;
      GetStorageData.writeData(
          "user_profile", profileModel.data?.first.toJson());

      Get.back();
      MySnackBar.showSnackBar(Get.context!, "Profile updated successfully",
          title: "Success", mode: AlertMode.success);
      updatePageStatus = PageStatus.success;
    }

    if (dataState is DataFailed) {
      MySnackBar.showSnackBar(Get.context!, dataState.error ?? "",
          title: "Error", mode: AlertMode.error);
      updatePageStatus = PageStatus.error;
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
}
