import 'dart:math';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:get/get.dart';

import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_model.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_params.dart';
import 'package:movie_chi/features/feature_login_screen/domain/usecase/otp_usecase.dart';
import 'package:movie_chi/features/feature_plans/data/models/plan_model.dart';
import 'package:movie_chi/features/feature_plans/domain/usecase/plan_usecase.dart';

import '../screens/plan_paid.dart';

class PlanScreenController extends GetxController {
  final PlanUseCase planUseCase;
  PageStatus pageStatus = PageStatus.loading;
  PageStatus paidPageStatus = PageStatus.loading;
  bool isPremium = false;
  late ConfettiController controllerCenter;
  PlanScreenController(this.planUseCase, this.authService);

  final OTPUseCase authService;
  late final bool loadPlan;

  PlanModel plan = PlanModel();
  bool monthly = false;

  List<PlanData> monthlyPlan = [];
  List<PlanData> monthy3Plan = [];

  changeMonthlyStatus(bool monthlyMode) {
    monthly = monthlyMode;

    if (monthly == false) {
      plan.data = monthlyPlan;
    }
    if (monthly != false) {
      plan.data = monthy3Plan;
    }
    update();
  }

  @override
  void dispose() {
    controllerCenter.dispose();
    super.dispose();
  }

  @override
  void onReady() {
    controllerCenter =
        ConfettiController(duration: const Duration(seconds: 40));
    super.onReady();
  }

  getPlans() async {
    pageStatus = PageStatus.loading;
    monthlyPlan.clear();
    monthy3Plan.clear();
    DataState dataState = await planUseCase.getPlans();

    if (dataState is DataSuccess) {
      plan = dataState.data as PlanModel;

      for (var item in plan.data!) {
        if (item.planTimeDay == "30") {
          monthlyPlan.add(item);
        }
        if (item.planTimeDay == "90") {
          monthy3Plan.add(item);
        }
      }

      // if (monthly) {
      plan.data = monthlyPlan;
      update();
      // }
      pageStatus = PageStatus.success;
    }
    if (dataState is DataFailed) {
      Constants.showGeneralSnackBar("خطا ", "خطا دریافت اطلاعات");
      pageStatus = PageStatus.error;
    }
    update();
  }

  Future<bool> checkAndGo() async {
    DataState dataState = await authService.loginUser(UserLoginParams(
        "",
        GetStorageData.getData("user_auth") ?? "",
        "",
        "",
        "",
        GetStorageData.getData("user_tag") ?? ""));

    if (dataState is DataSuccess) {
      UserLoginModel model = dataState.data as UserLoginModel;

      if (model.userStatus == "premium") {
        String timeOut = model.timeOutPremium ?? "0";
        DateTime expireTimeOut = (DateTime.parse(timeOut));
        DateTime now = (DateTime.now());
        GetStorageData.writeData("time_out_premium", model.timeOutPremium);
        GetStorageData.writeData("download_max", model.downloadMax);
        if (expireTimeOut.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
          Constants.showGeneralSnackBar("خطا", "اشتراک شما به پایان رسیده است");
          GetStorageData.writeData("time_out_premium", model.timeOutPremium);
          GetStorageData.writeData("download_max", model.downloadMax);
          GetStorageData.writeData("is_premium", false);
          return false;
        } else {
          // check download count
          int downloadMax = int.parse(model.downloadMax ?? "0");

          int userDownloaded = (GetStorageData.getData("downloaded_item") ?? 0);

          if (userDownloaded >= downloadMax && downloadMax != -1) {
            return false;
          }

          if ((GetStorageData.getData("is_premium") ?? false) != true) {
            Get.to(() => const PlanPaid());

            return true;
          }

          if ((await GetStorageData.getData("plan_viewed") ?? false) == true) {
            Get.off(() => const PlanPaid());
            return true;
          }
        }
        // GetStorageData.writeData("user_tag", model.userTag);
        // GetStorageData.writeData("user_status", model.userStatus);
        // GetStorageData.writeData("fullName", model.fullName);

        GetStorageData.writeData("time_out_premium", model.timeOutPremium);
        GetStorageData.writeData("download_max", model.downloadMax);

        // GetStorageData.writeData("is_premium", false);
      } else {
        // UserLoginModel model = (dataState.data);
        GetStorageData.writeData("user_tag", model.userTag);
        GetStorageData.writeData("user_status", model.userStatus);
        GetStorageData.writeData("fullName", model.fullName);

        GetStorageData.writeData("time_out_premium", model.timeOutPremium);
        GetStorageData.writeData("download_max", model.downloadMax);

        GetStorageData.writeData("is_premium", false);
      }
      GetStorageData.writeData("plan_viewed", false);
    }
    return false;
  }
  //on update

  checkUserPlan() async {
    paidPageStatus = PageStatus.loading;
    DataState dataState = await authService.loginUser(UserLoginParams(
        "",
        GetStorageData.getData("user_auth") ?? "",
        "",
        "",
        "",
        GetStorageData.getData("user_tag")));

    if (dataState is DataSuccess) {
      UserLoginModel model = dataState.data as UserLoginModel;

      if (model.userStatus == "premium") {
        isPremium = true;
        controllerCenter.play();
        UserLoginModel model = (dataState.data);
        GetStorageData.writeData("user_tag", model.userTag);
        GetStorageData.writeData("user_status", model.userStatus);
        GetStorageData.writeData("fullName", model.fullName);

        GetStorageData.writeData("time_out_premium", model.timeOutPremium);
        GetStorageData.writeData("download_max", model.downloadMax);

        GetStorageData.writeData("is_premium", true);
      } else {
        isPremium = false;
      }
      paidPageStatus = PageStatus.success;
    } else {
      paidPageStatus = PageStatus.error;
    }

    update();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
