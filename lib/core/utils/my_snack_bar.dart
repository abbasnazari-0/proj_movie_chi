import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AlertMode { success, error, warning, info }

class MySnackBar {
  static void showSnackBar(BuildContext context, String message,
      {AlertMode mode = AlertMode.success, String title = ""}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      // backgroundColor: Colors.red,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      backgroundGradient: LinearGradient(
        colors: mode == AlertMode.success
            ? [Colors.green, Colors.greenAccent]
            : mode == AlertMode.warning
                ? [Colors.orange, Colors.orangeAccent]
                : mode == AlertMode.info
                    ? [Colors.blue, Colors.blueAccent]
                    : [Colors.red, Colors.redAccent],
      ),
      icon: mode == AlertMode.success
          ? const Icon(
              Icons.check_circle,
              color: Colors.white,
            )
          : mode == AlertMode.warning
              ? const Icon(
                  Icons.warning,
                  color: Colors.white,
                )
              : mode == AlertMode.info
                  ? const Icon(
                      Icons.info,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
      shouldIconPulse: true,
      isDismissible: true,
      // showProgressIndicator: true,
      // progressIndicatorBackgroundColor: Colors.white,
      // overlayBlur: 1.0,
      progressIndicatorValueColor:
          const AlwaysStoppedAnimation<Color>(Colors.red),
      // progressIndicatorController: Get.find(),
    );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: MyText(txt: message),
    //     duration: const Duration(seconds: 2),
    //     backgroundColor: Colors.red,
    //     margin: EdgeInsets.all(10),
    //   ),
    // );
  }
}
