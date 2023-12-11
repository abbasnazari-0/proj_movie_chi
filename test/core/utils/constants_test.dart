import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_chi/core/utils/constants.dart';

void main() {
  // set platform to android

  WidgetsFlutterBinding.ensureInitialized();

  test("should be return true", () {
    var result = Constants.allowToShowAd();

    expect(false, result);
  });

  test("version application test: should be 60", () async {
    var res = await Constants.versionApplication();
    expect(res, 60);
  });
}
