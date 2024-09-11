// ignore_for_file: unused_local_variable, unnecessary_null_comparison
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_chi/core/utils/database_helper.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/features/feature_new_notification/presentation/controllers/news_page_controller.dart';
import 'package:movie_chi/features/feature_support/presentation/controllers/support_page_controller.dart';
import 'package:movie_chi/firebase_options.dart';
import 'package:movie_chi/locator.dart';
import 'package:platform_local_notifications/platform_local_notifications.dart';
import 'package:movie_chi/core/utils/constants.dart';

class LocalNotificationService {
// It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage() ??
            const RemoteMessage();

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

      if (notifData['type'] == 'news') {
        bool hasRegestred = Get.isRegistered<NewsPageController>();
        if (hasRegestred) {
          final controller = Get.find<NewsPageController>();
          controller.refreshAgain();
        }
      }
      if (notifData['type'] == 'support_message') {
        bool hasRegestred = Get.isRegistered<SupportPageController>();
        if (hasRegestred) {
          final controller = Get.find<SupportPageController>();
          controller.refreshAgain();
        }
      }
      if (notifData['type'] == 'video') {
        Constants.openVideoDetail(
            vidTag: notifData['tag'], picture: "", deepLink: true);
      }
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    if (message.data['action'] == null || message.data['action'] == "") {
      var payload = json.decode(message.data['action'] ?? "{}");

      if (payload['type'] == 'video' || payload['type'] == 'support_message') {
        await GetStorage.init();
        // write notification click to database
        GetStorageData.writeData("has_notif", true);
        GetStorageData.writeData("notif_data", payload);
      }
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

    await FirebaseMessaging.instance.subscribeToTopic('all');
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    messaging.setAutoInitEnabled(true);
    messaging.requestPermission(
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

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

    var payload = json.decode(message.data['action']);

    DictionaryDataBaseHelper dbHelper = locator();
    Map newsData = (jsonDecode(payload['tag']));

    await dbHelper.init();

    List queryData = await dbHelper.getQuery('tbl_news_notif',
        where: 'tag', whereValue: newsData['tag']);
    if (queryData.isEmpty) {
      int x = await dbHelper.addQuery(
          '`title`, `desc`, `action`, `action_content`, `tag`, `readed`',
          "'${newsData['title']}', '${newsData['desc']}', '${newsData['action']}', '${newsData['action_content']}', '${newsData['tag']}', 0",
          'tbl_news_notif');
    }

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
      (event) async {
        if (event is PluginNotificationClickAction) {
          //handle when user click on the notification

          var payload = json.decode(event.payload ?? "{}");

          if (payload['type'] == 'video') {
            Constants.openVideoDetail(vidTag: payload['tag'], picture: "");
          }
          if (payload['type'] == 'support_message') {
            bool hasRegestred = Get.isRegistered<SupportPageController>();
            if (hasRegestred) {
              final controller = Get.find<SupportPageController>();
              controller.refreshAgain();
            } else {
              Constants.openSupportMessages();
            }
          }

          if (payload['type'] == 'news') {
            bool hasRegestred = Get.isRegistered<NewsPageController>();
            if (hasRegestred) {
              final controller = Get.find<NewsPageController>();
              controller.refreshAgain();
            } else {
              Constants.openNewsPage();
            }
          }
        }
        if (event is PluginNotificationReplyAction) {
          //handle when user choose reply action
          debugPrint("reply");
        }
        if (event is PluginNotificationMarkRead) {
          //handle when user submit value to reply textile
          debugPrint("mark");
        }
      },
    );
  }
}
