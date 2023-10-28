import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class WebSuggestWrapper {
  static show() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF17191A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon.png',
                height: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              const MyText(
                txt: "مووی چی!",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                size: 30,
              ),
              const SizedBox(
                height: 20,
              ),
              const MyText(
                  txt: "لطفا از گوشی آیفونی خود استفاده کنید ",
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ));
  }
}
