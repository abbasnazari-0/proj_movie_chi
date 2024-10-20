import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/divider_with_text.dart';
import 'package:movie_chi/core/widgets/my_button.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/controllers/google_login_controller.dart';
import 'package:pinput/pinput.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/locator.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/login_screen_controller.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login_screen';
  LoginScreen({super.key});
  final numbercontroller = TextEditingController();
  final codecontroller = TextEditingController();
  final focusNode = FocusNode();
  final authControlle = Get.put(LoginScreenController(authService: locator()));
  final googleLoginController = Get.put(GoogleLoginController());
  static const borderColor = Color.fromRGBO(30, 60, 87, 100);

  final cursor = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 56,
        height: 3,
        decoration: BoxDecoration(
          color: borderColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (authControlle.pageNumber == 0) {
          return true;
        } else {
          authControlle.pageNumber = 0;
          authControlle.update();
          return false;
        }
      },
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            scrollController.animateTo(
              scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          } else if (event.logicalKey == LogicalKeyboardKey.select ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            Get.back();
          }
        },
        child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(top: 30, right: 20),
              child: FloatingActionButton(
                autofocus: false,
                onPressed: () {
                  Get.back();
                },
                backgroundColor: Theme.of(context).colorScheme.background,
                child: Icon(Iconsax.arrow_right,
                    color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 600) //tablet, tv, pc

              {
                //

                return GetBuilder<LoginScreenController>(
                    id: "tablet",
                    initState: (state) {
                      // requestNewDevice();
                      authControlle
                          .requestNewDevice(GetStorageData.getData('user_tag'));
                    },
                    builder: (screenController) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: screenController.requestinNewDevice ==
                                    PageStatus.loading
                                ? [
                                    const CircularProgressIndicator(),
                                    const Gap(10),
                                    const MyText(
                                        txt: 'در حال ساخت کد ...',
                                        fontWeight: FontWeight.bold),
                                  ]
                                : [
                                    QrCodeSection(),
                                  ],
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 4,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Gap(30),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        // padding: const EdgeInsets.all(20),
                                        height: height * 0.09,
                                        width: height * 0.09,
                                        child: const Center(
                                          child: Icon(
                                            Icons.arrow_back_ios_new,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Gap(30),
                                    const MyText(
                                      txt:
                                          "۱- برای ورود ابتدا به قسمت تنظمیات کاربری رفته ",
                                      color: Colors.white,
                                    ),
                                    const Gap(10),
                                    Image.asset(
                                      'assets/images/tv-1-intro.png',
                                      height: height * 0.5,
                                    ),

                                    const Gap(10),
                                    const MyText(
                                      txt:
                                          "۲- سپس روی گزینه 'افزودن دستگاه جدید' بزنید",
                                      color: Colors.white,
                                    ),
                                    const Gap(10),
                                    Image.asset(
                                      'assets/images/tv-2-intro.jpg',
                                      height: height * 0.5,
                                    ),
                                    const Gap(10),
                                    const MyText(
                                      txt:
                                          "سپس، QR کد را اسکن کنید و یا کد مشاهده شده را وارد کنید",
                                      color: Colors.white,
                                    ),

                                    const Gap(30),
                                    // CircularProgressIndicator(),
                                    // MyText(
                                    //     txt: 'در حال ساخت کد ...',
                                    //     fontWeight: FontWeight.bold),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              } else {
                return GetBuilder<LoginScreenController>(
                    builder: (screenController) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lotties/otp.json',
                            width: width * 0.8),
                        SizedBox(height: height * 0.03),
                        const MyText(
                            txt: 'ورود با شماره همراه',
                            fontWeight: FontWeight.bold),
                        SizedBox(height: height * 0.03),
                        if (authControlle.pageNumber == 0)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                              controller: numbercontroller,
                              focusNode: focusNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: '09xx xxx xxxx',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: borderColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: borderColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: borderColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (authControlle.pageNumber == 1)
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Pinput(
                                length: 6,
                                closeKeyboardWhenCompleted: true,

                                errorText: "ddd",
                                controller: codecontroller,
                                defaultPinTheme: defaultPinTheme,
                                // focusedPinTheme: focusedPinTheme,
                                // submittedPinTheme: submittedPinTheme,
                                pinputAutovalidateMode:
                                    PinputAutovalidateMode.onSubmit,
                                showCursor: true,
                                onCompleted: (pin) =>
                                    authControlle.verifyOTPCode(
                                        codecontroller.text,
                                        numbercontroller.text),
                                // set color
                              ),
                            ),
                          ),
                        SizedBox(height: height * 0.03),
                        MyText(
                            txt: screenController.logTitle,
                            fontWeight: FontWeight.normal,
                            textAlign: TextAlign.center,
                            color: Colors.red),
                        SizedBox(height: height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: MyButton(
                              loading: authControlle.otpSenderOTP ==
                                  PageStatus.loading,
                              color: Colors.red,
                              text: authControlle.pageNumber == 1
                                  ? "تایید"
                                  : 'ارسال کد تایید',
                              textColor: Colors.white,
                              icon: Icons.arrow_forward,
                              // loading: ,
                              onPressed: () async {
                                if (authControlle.pageNumber == 1) {
                                  await authControlle.verifyOTPCode(
                                      codecontroller.text,
                                      numbercontroller.text);
                                }
                                if (authControlle.pageNumber == 0) {
                                  authControlle.sendCode(numbercontroller);
                                }
                              }),
                        ),
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(20),
                        //   child: SizedBox(
                        //     width: width * 0.8,
                        //     height: height * 0.06,
                        //     child: ElevatedButton(
                        //       onPressed: () {
                        //         if (authControlle.pageNumber == 1) {
                        //           authControlle.verifyOTPCode(
                        //               codecontroller.text, numbercontroller.text);
                        //         }
                        //         if (authControlle.pageNumber == 0) {
                        //           authControlle.sendCode(numbercontroller);
                        //         }
                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: Colors.red,
                        //       ),
                        //       child: MyText(
                        //         txt: authControlle.pageNumber == 1
                        //             ? "تایید"
                        //             : 'ارسال کد تایید',
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(height: 20),
                        if (authControlle.pageNumber == 0)
                          Column(
                            children: [
                              const DividerWithText(
                                  horizontalPadding: 100, text: "یا ورود با"),
                              IconButton(
                                onPressed: () {
                                  googleLoginController.login();
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Colors.grey.withAlpha(100))),
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.all(5),
                                  child: Logo(Logos.google),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                });
              }
            })),
      ),
    );
  }
}

class QrCodeSection extends StatelessWidget {
  QrCodeSection({
    super.key,
  });
  final screenController = Get.find<LoginScreenController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const MyText(
            txt: 'برای ورود به اپلیکیشن \nاز "کیو آر کد" زیر استفاده کنید',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            textAlign: TextAlign.center,
          ),
          const Gap(20),
          QrImageView(
            data: screenController.requestDeviceModel.data?.token ?? "",
            version: QrVersions.auto,
            size: 200.0,
          ),
          const Gap(20),
          const Divider(
            color: Colors.grey,
            indent: 20,
            endIndent: 20,
          ),
          const Gap(20),
          const MyText(
            txt: 'و یا کد زیر را وارد کنید',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          const Gap(20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(50),
              borderRadius: BorderRadius.circular(20),
            ),
            child: MyText(
              txt: screenController.requestDeviceModel.data?.tokenId ?? "",
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
