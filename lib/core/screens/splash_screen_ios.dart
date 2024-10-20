import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/screens/home_io_screen.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class SplashIOS extends StatefulWidget {
  const SplashIOS({super.key});

  @override
  State<SplashIOS> createState() => _SplashIOSState();
}

class _SplashIOSState extends State<SplashIOS> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => const HomeIOSScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon.png',
              // fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            const SizedBox(
              height: 20,
            ),
            // const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            const MyText(
              txt: 'MovieChi',
              size: 20,
              fontWeight: FontWeight.bold,
            ),
            const MyText(
              txt: 'the online video player',
            ),
          ],
        ),
      ),
    );
  }
}
