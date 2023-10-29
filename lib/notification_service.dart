// ignore_for_file: unused_local_variable, unnecessary_null_comparison
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/detail_page_controller.dart';
import 'package:movie_chi/firebase_options.dart';
import 'package:platform_local_notifications/platform_local_notifications.dart';
import 'package:movie_chi/core/utils/constants.dart';

class LocalNotificationService {
// It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    await _firebaseMessagingBackgroundHandler(message);

    bool hasNotifData =
        (await GetStorageData.readDataWithAwaiting("has_notif") ?? false);
    if (hasNotifData == true) {
      Map notifData = await GetStorageData.readDataWithAwaiting("notif_data");

      bool hasRegestred = Get.isRegistered<DetailPageController>();

      if (hasRegestred) {
        Constants.openVideoDetail(
            vidTag: notifData['tag'], picture: "", deepLink: true);
      }
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    var payload = json.decode(message.data['action']);

    if (payload['type'] == 'video') {
      await GetStorage.init();
      // write notification click to database
      GetStorageData.writeData("has_notif", true);
      GetStorageData.writeData("notif_data", payload);
    }
  }

  // ignore: unused_field
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await PlatformNotifier.I.init(appName: "مووی چی!");

    NotificationSettings? isAcceptedable = await FirebaseMessaging.instance
        .requestPermission(sound: true, alert: true);

    bool? isAccepted = await PlatformNotifier.I.requestPermissions();
    // set to getstragedate
    GetStorageData.writeData("notif_accepted", isAccepted);

    var messaging = FirebaseMessaging.instance;
    var token = await messaging.getToken();
    GetStorageData.writeData("user_noti", token);
    debugPrint("user token is $token");

    try {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      debugPrint("has not background message");
    }

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        LocalNotificationService.display(message);
      }
    });

    setupInteractedMessage();
  }

  static Future<void> display(RemoteMessage message) async {
    // // To display the notification in device

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    Dio dio = Dio();
    final response = await dio.get(message.data['image'],
        options: Options(responseType: ResponseType.bytes));
    var bigPictureStyleInformation = BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(
        base64Encode(response.data),
      ),

      // hideExpandedLargeIcon: true,
    );

    await PlatformNotifier.I.showPluginNotification(
        ShowPluginNotificationModel(
          id: DateTime.now().second,
          title: message.notification?.title ?? "title",
          body: message.notification?.body ?? "body",
          payload: message.data["action"] ?? "test",
          androidNotificationDetails: AndroidNotificationDetails(
            "Channel Id",
            "Main Channel",
            priority: Priority.high,
            icon: "@mipmap/ic_launcher_notif",
            groupKey: "cinimo",
            styleInformation: message.data['image'] != null
                ? bigPictureStyleInformation
                : null,
          ),
        ),
        Get.context!);
    setUpStreams();
  }

  static Future<void> displayLocal() async {
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();

    // // To display the notification in device
    // try {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    Dio dio = Dio();
    final response = await dio.get(
        "https://files.cinimo.ir/cinimo/images/cargyvzgpeppzabpdzxy.jpg",
        options: Options(responseType: ResponseType.bytes));
    var bigPictureStyleInformation = BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(
        base64Encode(response.data),
      ),

      // hideExpandedLargeIcon: true,
    );
    await PlatformNotifier.I.showPluginNotification(
        ShowPluginNotificationModel(
            id: DateTime.now().second,
            title: "title",
            body: "body",
            payload: json.encode({"type": "video", "tag": "X0Pi5SVKRMZZC3Z"}),
            androidNotificationDetails: AndroidNotificationDetails(
              "Channel Id",
              "Main Channel",
              icon: "@mipmap/ic_launcher_notif",
              groupKey: "cinimo",
              styleInformation:
                  'image' != null ? bigPictureStyleInformation : null,
            )),
        Get.context!);

    setUpStreams();
  }

  static void setUpStreams() {
    PlatformNotifier.I.platformNotifierStream.listen(
      (event) {
        if (event is PluginNotificationClickAction) {
          //handle when user click on the notification

          var payload = json.decode(event.payload!);

          if (payload['type'] == 'video') {
            // Get.to(() => DetailPage(
            //       vid_tag: payload['tag'],
            //     ));
            Constants.openVideoDetail(vidTag: payload['tag'], picture: "");
          }
        }
        if (event is PluginNotificationReplyAction) {
          //handle when user choose reply action
          print("reply");
        }
        if (event is PluginNotificationMarkRead) {
          //handle when user submit value to reply textile
          print("mark");
        }
      },
    );
  }
}
