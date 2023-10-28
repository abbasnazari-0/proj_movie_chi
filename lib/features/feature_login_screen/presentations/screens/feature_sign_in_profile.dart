import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/params/sign_in_profile_screen.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/controllers/sign_in_profile_controller.dart';
import 'package:movie_chi/locator.dart';
import 'package:pinput/pinput.dart';

class SignInProfileScreen extends StatefulWidget {
  const SignInProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInProfileScreen> createState() => _SignInProfileScreenState();
}

class _SignInProfileScreenState extends State<SignInProfileScreen> {
  SignInParams signInParams = Get.arguments;

  final profileController =
      Get.put(SignInProfileController(authService: locator()));
  bool enabledEdit = false;

  @override
  void initState() {
    super.initState();
    profileController.name.setText(signInParams.fullName);
    profileController.signInParams = Get.arguments;
    if (signInParams.fullName == "") {
      enabledEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Get.theme.colorScheme.onSecondary,
                        Get.theme.colorScheme.secondary.withAlpha(50),
                      ],
                      end: Alignment.topLeft,
                      begin: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(99),
                      bottomRight: Radius.circular(99),
                    )),
                height: size.height * 0.35,
                width: size.width,
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.35 - 40),
                    // user profile
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9999),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(signInParams
                                      .photoUrl ??
                                  "https://github.com/mosbahsofttechnology/cinimo/assets/49541849/9d6aedb4-58c0-4adc-9c67-fbc05f229f66"))),
                      height: 80,
                      width: 80,
                    ),

                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IntrinsicWidth(
                          child: TextField(
                            enabled: enabledEdit,
                            textAlign: TextAlign.center,
                            controller: profileController.name,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: enabledEdit == true
                                    ? "لطفا نام مورد نظر را وارد کنید"
                                    : ""),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "vazir",
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                enabledEdit = !enabledEdit;
                                if (enabledEdit == true) {
                                  profileController.name.setText("");
                                } else {
                                  profileController.name
                                      .setText(signInParams.fullName);
                                }
                              });
                            },
                            icon: const Icon(Icons.edit_rounded)),
                      ],
                    ),
                    // MyText(
                    //     txt: ,
                    //     color: Colors.white,
                    //     fontWeight: FontWeight.bold,
                    //     size: 20.sp),
                    MyText(
                        txt: signInParams.email,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        size: 14.sp),
                    SizedBox(height: size.height * 0.05),
                    MyText(
                        txt: "شما با موفقیت وارد شدید",
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        size: 14.sp),
                    SizedBox(height: size.height * 0.1),
                    EasyButton(
                      type: EasyButtonType.elevated,

                      idleStateWidget: const MyText(
                          txt: "شروع", fontWeight: FontWeight.bold),

                      // Content inside of the button when the button state is loading.
                      loadingStateWidget: const CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                      useWidthAnimation: true,
                      contentGap: 6.0,
                      borderRadius: 99.0,
                      width: size.width * 0.8,
                      height: size.height * 0.06,
                      useEqualLoadingStateWidgetDimension: false,
                      onPressed: profileController.startApp,
                    ),

                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(20),
                    //   child: SizedBox(
                    //     width: size.width * 0.8,
                    //     height: size.height * 0.06,
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         // Get.close(0);
                    //         profileController.startApp();
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.red,
                    //       ),
                    //       child: const MyText(
                    //         txt: "ادامه",
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
