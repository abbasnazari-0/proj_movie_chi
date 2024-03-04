import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/widgets/divider_with_text.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/controllers/google_login_controller.dart';
import 'package:pinput/pinput.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/locator.dart';

import '../controllers/login_screen_controller.dart';

class LoginScreen extends StatelessWidget {
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
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: GetBuilder<LoginScreenController>(builder: (screenController) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/lotties/otp.json', width: width * 0.8),
                SizedBox(height: height * 0.03),
                const MyText(
                    txt: 'ورود با شماره همراه', fontWeight: FontWeight.bold),
                SizedBox(height: height * 0.03),
                if (authControlle.pageNumber == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Pinput(
                        length: 6,
                        closeKeyboardWhenCompleted: true,
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsRetrieverApi,
                        errorText: "ddd",
                        controller: codecontroller,
                        defaultPinTheme: defaultPinTheme,
                        // focusedPinTheme: focusedPinTheme,
                        // submittedPinTheme: submittedPinTheme,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        onCompleted: (pin) => debugPrint(pin),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: width * 0.8,
                    height: height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (authControlle.pageNumber == 1) {
                          authControlle.verifyOTPCode(
                              codecontroller.text, numbercontroller.text);
                        }
                        if (authControlle.pageNumber == 0) {
                          authControlle.sendCode(numbercontroller);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: MyText(
                        txt: authControlle.pageNumber == 1
                            ? "تایید"
                            : 'ارسال کد تایید',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const DividerWithText(horizontalPadding: 100, text: "یا ورود با"),
                IconButton(
                  onPressed: () {
                    googleLoginController.login();
                  },
                  icon: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: Colors.transparent,
                        border: Border.all(color: Colors.grey.withAlpha(100))),
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(5),
                    child: Logo(Logos.google),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
