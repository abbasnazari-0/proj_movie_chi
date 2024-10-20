import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/params/sign_in_profile_screen.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/my_button.dart';
import 'package:movie_chi/core/widgets/my_text_field.dart';
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
              GetBuilder<SignInProfileController>(builder: (controller) {
                return Center(
                  child: profileController.pageStatus != PageStatus.loading
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: size.height * 0.1),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                          radius: 54,
                                          backgroundColor: Colors.grey,
                                          foregroundImage: profileController
                                                      .pickerFile !=
                                                  null
                                              ? FileImage(File(profileController
                                                      .pickerFile?.path ??
                                                  ""))
                                              : null,
                                          backgroundImage: profileController
                                                      .pickerFile !=
                                                  null
                                              ? null
                                              : CachedNetworkImageProvider(
                                                  profileController.pathImage),
                                          child: const Icon(
                                            Icons.person,
                                            size: 50,
                                          )),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            profileController.chooseImage();
                                          },
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Gap(10),
                                  MyTextField(
                                    text: 'نام',
                                    prefixIcon: Icons.person,
                                    textEditingController:
                                        profileController.name,
                                  ),
                                  MyTextField(
                                    text: 'نام خانوادگی',
                                    prefixIcon: Icons.person,
                                    textEditingController:
                                        profileController.fName,
                                  ),
                                  MyTextField(
                                    text: 'شماره تماس',
                                    textEditingController:
                                        TextEditingController(
                                            text: signInParams.email),
                                    enabled: false,
                                    prefixIcon: Icons.phone,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            const MyText(
                                txt: "شما با موفقیت وارد شدید!!!",
                                color: Colors.green,
                                fontWeight: FontWeight.normal,
                                size: 14),
                            SizedBox(height: size.height * 0.1),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: MyButton(
                                onPressed: profileController.startApp,
                                text: "شروع",
                                icon: Icons.arrow_forward,
                                isFilledColor: true,
                                color: Theme.of(context).colorScheme.secondary,
                                textColor: Colors.white,
                                loading: profileController.registerProfile ==
                                    PageStatus.loading,
                              ),
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
