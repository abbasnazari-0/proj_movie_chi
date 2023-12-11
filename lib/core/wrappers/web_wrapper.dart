import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WebWrapper {
  static show() async {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: const Size(320 * 1.5, 640 * 1.5),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      windowButtonVisibility: true,
      title: 'مووی چی!',
      maximumSize: Size(320 * 1.7, 640 * 1.5),
      minimumSize: const Size(320 * 1.5, 640 * 1.5),
      // maximumSize: await windowManager.getSize(),
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
