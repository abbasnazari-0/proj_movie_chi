import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/screens/player_io_screen.dart';
import 'package:movie_chi/core/screens/splash_screen.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/widgets/general_dialog.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class HomeIOSScreen extends StatefulWidget {
  const HomeIOSScreen({super.key});

  @override
  State<HomeIOSScreen> createState() => _HomeIOSScreenState();
}

class _HomeIOSScreenState extends State<HomeIOSScreen> {
  TextEditingController textEditingController = TextEditingController();

  Future<String> _getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    return (clipboardText ?? "");
  }

  onOpenUrl() {
    String txt = (textEditingController.text);
    // check is the url is valid
    // if valid open the url
    // else show error message

    if (txt.isNotEmpty) {
      // check if the url is valid

      if (txt == "salam") {
        GetStorageData.writeData('Authorizedd', true);
        Get.offAll(const Splash());

        return;
      }

      if (txt.contains('http') || txt.contains('https')) {
        
        Get.to(() => PlayerIOSScreen(url: txt));
      } else {
        GeneralDialog.show(
          Get.context!,
          "The url is not valid",
          "please enter valid Url",
          "Ok",
          () {},
        );
      }
    } else {
      // print('The url is empty');
    }
  }

  copyFromClipBoard() {
    _getClipboardText().then((value) {
      textEditingController.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Gap(10),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // color: Colors.blue,
                borderRadius: BorderRadius.circular(99),

                border: Border.all(color: Colors.white),
              ),
              // height: 70,
              width: double.infinity,
              child: Row(
                children: [
                  InkWell(
                    onTap: copyFromClipBoard,
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        height: 50,
                        // width: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Center(
                          child: MyText(
                            txt: 'Past',
                          ),
                        )),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter the URL',
                            hintStyle: TextStyle(color: Colors.white)),
                        // label: 'Enter the URL',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onOpenUrl,
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        height: 50,
                        // width: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Center(
                          child: MyText(
                            txt: 'Go',
                          ),
                        )),
                  ),
                ],
              ),
            ),
            const Spacer(),

            Center(
                child: Lottie.asset(
              'assets/lotties/Animation - 1728290020321.json',
              width: MediaQuery.of(context).size.width * 0.4,
            )),
            const Gap(20),
            const MyText(
              txt: 'Please Enter the URL',
              size: 20,
              fontWeight: FontWeight.bold,
            ),
            const MyText(
              txt: 'to watch the video',
            ),
            const Spacer(),

            // const Spacer(),
            // InkWell(
            //   onTap: () {
            //     Get.dialog(
            //         Container(
            //           // color: Colors.white,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20),
            //             color: Colors.white,
            //           ),
            //           width: MediaQuery.of(context).size.width * 0.5,
            //           height: MediaQuery.of(context).size.height * 0.5,
            //           margin: EdgeInsets.symmetric(
            //               horizontal: MediaQuery.of(context).size.width * 0.15,
            //               vertical: MediaQuery.of(context).size.height * 0.30),
            //           child: Material(
            //             child: Center(
            //                 child: Column(
            //               children: [
            //                 const Gap(10),
            //                 const MyText(
            //                   txt: 'Enter email',
            //                   size: 20,
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.blue,
            //                 ),
            //                 const Spacer(),
            //                 const Padding(
            //                   padding: EdgeInsets.all(20.0),
            //                   child: SizedBox(
            //                     height: 80,
            //                     width: double.infinity,
            //                     child: TextField(
            //                       decoration: InputDecoration(
            //                           border: OutlineInputBorder(),
            //                           hintText: 'Enter your email'),
            //                     ),
            //                   ),
            //                 ),
            //                 const Spacer(),
            //                 Padding(
            //                   padding: const EdgeInsets.all(20.0),
            //                   child: MyButton(
            //                     onPressed: () {},
            //                     text: 'Submit',
            //                   ),
            //                 ),
            //                 const Gap(10),
            //               ],
            //             )),
            //           ),
            //         ),
            //         useSafeArea: false);
            //   },
            //   child: Container(
            //     width: double.infinity,
            //     height: 50,
            //     decoration: BoxDecoration(
            //       color: Colors.blue,
            //       borderRadius: BorderRadius.circular(99),
            //     ),
            //     child: const Center(
            //       child: MyText(
            //         txt: 'Subscribe',
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
