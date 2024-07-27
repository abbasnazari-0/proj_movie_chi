import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/features/feature_profile/data/models/profile_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Utils {
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
