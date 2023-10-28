import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';

import '../../../../core/params/notification_subscribe.dart';
import '../../../../core/utils/database_helper.dart';
import '../../../../locator.dart';
import '../../domain/usecases/video_detail_usecase.dart';

class NotifyController extends GetxController {
  var notify = false;
  final String tag;
  final VideoDetailUseCase videoDetailUseCase;

  NotifyController(this.tag, this.videoDetailUseCase);

  final DictionaryDataBaseHelper _dbHelper = locator();

  @override
  void onInit() {
    super.onInit();
    notifyStatus();
  }

  notifyStatus() async {
    var status =
        await _dbHelper.getQuery("tbl_notif", where: "tag", whereValue: tag);

    if (status.isNotEmpty) {
      setNotify(true);
    }
  }

  Future<void> setNotify(bool value) async {
    var messaging = FirebaseMessaging.instance;

    try {
      var token = await messaging.getToken();
      debugPrint('user token is: $token');

      notify = value;
      submittoServer(value, token ?? "");
      update();
    } catch (e) {
      Get.rawSnackbar(
        message: "لطفا نوتیفکیشن در گوشی خود را فعال کنید",
      );

      return;
    }
  }

  notifyChanger() async {
    if (notify) {
      await _dbHelper.query("DELETE FROM tbl_notif WHERE tag = '$tag'");
      setNotify(false);
    } else {
      await _dbHelper.addQuery("tag, status", "'$tag', 1", "tbl_notif");
      setNotify(true);
    }
  }

  submittoServer(bool status, String token) async {
    DataState dataState = await videoDetailUseCase
        .subscribeNotification(NotificationSubscribeParams(
      userTag: GetStorageData.getData("user_tag"),
      userToken: token,
      status: status ? 'subscribe' : 'unsubscribe',
      tag: tag,
    ));

    if (dataState is DataSuccess) {
      Get.rawSnackbar(
        message: status
            ? "اطلاع رسانی با موفقیت ثبت شد"
            : "اطلاع رسانی با موفقیت لغو شد",
      );
    }
    if (dataState is DataFailed) {
      Get.rawSnackbar(
        message: "خطا در ثبت اطلاع رسانی",
      );
    }
  }
}
