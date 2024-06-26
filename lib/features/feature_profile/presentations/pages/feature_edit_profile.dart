import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/my_button.dart';
import 'package:movie_chi/core/widgets/my_text_field.dart';
import 'package:movie_chi/features/feature_profile/presentations/controllers/edit_profile_controller.dart';
import 'package:movie_chi/locator.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        body: GetBuilder<EditProfileController>(
            init: EditProfileController(locator()),
            builder: (controller) {
              if (controller.pageStatus == PageStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SafeArea(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Gap(20),
                      Stack(
                        children: [
                          CircleAvatar(
                              radius: 54,
                              backgroundColor: Colors.grey,
                              foregroundImage: controller.pickerFile != null
                                  ? FileImage(
                                      File(controller.pickerFile?.path ?? ""))
                                  : null,
                              backgroundImage: controller.pickerFile != null
                                  ? null
                                  : CachedNetworkImageProvider(
                                      controller.pathImage),
                              child: const Icon(
                                Icons.person,
                                size: 50,
                              )),
                          // if (controller.hasImage)
                          //   ClipRRect(
                          //     borderRadius: BorderRadius.circular(11),
                          //     child: CachedNetworkImage(
                          //       imageUrl: controller.pathImage,
                          //       fit: BoxFit.cover,
                          //       // cacheManager: CustomCacheManager(),
                          //     ),
                          //   ),
                          // if (controller.pickerFile != null)
                          //   ClipRRect(
                          //     borderRadius: BorderRadius.circular(11),
                          //     child: Image.file(
                          //       File(controller.pickerFile?.path ?? ""),
                          //       fit: BoxFit.cover,
                          //       colorBlendMode: BlendMode.darken,
                          //       color: Colors.black38,
                          //     ),
                          //   ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                controller.chooseImage();
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            MyTextField(
                              text: 'نام',
                              prefixIcon: Icons.person,
                              textEditingController: controller.nameController,
                            ),
                            MyTextField(
                              text: 'نام خانوادگی',
                              prefixIcon: Icons.person,
                              textEditingController:
                                  controller.familyController,
                            ),
                            MyTextField(
                              text: 'شماره تماس',
                              prefixIcon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textEditingController: controller.phoneController,
                            ),
                            const Gap(20),
                            MyButton(
                              loading: controller.updatePageStatus ==
                                  PageStatus.loading,
                              text: 'ذخیره',
                              color: Theme.of(context).colorScheme.primary,
                              textColor: Colors.black,
                              onPressed: () {
                                controller.updateProfile();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
