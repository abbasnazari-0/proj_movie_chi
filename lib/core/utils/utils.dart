import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/random_string.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/location_ip_model.dart';
import 'package:movie_chi/features/feature_detail_page/domain/usecases/video_detail_usecase.dart';
import 'package:movie_chi/features/feature_profile/data/models/profile_model.dart';
import 'package:movie_chi/locator.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Utils {
  isallowToPlay() async {
    final VideoDetailUseCase videoDetailUseCase = locator();
    DataState data = await videoDetailUseCase.getLocationFromIp();

    if (data is DataSuccess) {
      LocationModel locationModel = data.data;

      if (locationModel.country == null) return false;

      if (locationModel.country?.toLowerCase() == "ir") {
        return true;
      } else {
        return false;
      }
    }
    if (data is DataFailed) {
      debugPrint(data.error);
    }
  }

  checkUSers() async {
    if (dotenv.env['APP_ACCESS'] == "true" &&
        GetStorageData.getData("user_tag") != null) {
      GetStorageData.writeData("logined", true);
      GetStorageData.writeData('Authorizedd', true);
      return;
    }
    bool canSeeVide = await isallowToPlay();

    if (canSeeVide) {
      //launch mx
      GetStorageData.writeData("logined", true);
      GetStorageData.writeData('Authorizedd', true);
    } else {
      if (GetStorageData.getData("user_tag") != null) {
        GetStorageData.writeData("user_tag", generateRandomString(20));
      }
      GetStorageData.writeData("logined", false);
      GetStorageData.writeData("Authorizedd", false);
    }
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumber = packageInfo.buildNumber;
    return buildNumber;
  }

  // 2. compress file and get file.
  Future<XFile?> testCompressAndGetFile(XFile file, {int quality = 20}) async {
    String targetPath = file.path
        .split('/')
        .sublist(0, file.path.split('/').length - 1)
        .join('/');

    // print('pathWithouFileName = $pathWithouFileName');
    // String newTargetFilePath = file.path.split('/').last;
    var result = await FlutterImageCompress.compressAndGetFile(
        file.path, "$targetPath/${DateTime.now().millisecondsSinceEpoch}.jpg",
        quality: quality, inSampleSize: 3

        // format: CompressFormat.png,
        );

    return result;
  }

  ProfileModelData getProfileData() {
    ProfileModelData profileModel =
        GetStorageData.getData("user_profile") == null
            ? ProfileModelData(
                fullName: GetStorageData.getData("fullName") ?? "",
                userAuth: GetStorageData.getData("user_auth") ?? "",
              )
            : ProfileModelData.fromJson(
                GetStorageData.getData("user_profile") ?? {});

    return profileModel;
  }
}
