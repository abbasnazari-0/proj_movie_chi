import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/screens/splash_screen.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/photo_viewer_screen.dart';
import 'package:movie_chi/core/utils/utils.dart';
import 'package:movie_chi/core/widgets/general_dialog.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_critism/presentation/pages/criticism_page.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/last_played.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/saved_screen.dart';
import 'package:movie_chi/features/feature_plans/presentation/screens/plan_screen.dart';
import 'package:movie_chi/features/feature_profile/presentations/controllers/add_device_controller.dart';
import 'package:movie_chi/features/feature_profile/presentations/pages/feature_edit_profile.dart';
import 'package:movie_chi/features/feature_profile/presentations/widgets/setting_item.dart';
import 'package:movie_chi/features/feature_support/presentation/pages/support_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userStatusLabel() {
    int downloadMax = int.parse(GetStorageData.getData("download_max"));
    DateTime dateTime =
        DateTime.parse(GetStorageData.getData("time_out_premium"));
    String userStatus = (GetStorageData.getData("user_status"));

    int userDownloaded = (GetStorageData.getData("downloaded_item") ?? 0);

    if (userStatus == "free_user") {
      return "وضعیت اشتراک: غیرفعال";
    } else {
      if (DateTime.now().isAfter(dateTime)) {
        return "وضعیت اشتراک: غیرفعال";
      } else {
        return "وضعیت اشتراک: فعال \nروزی های مانده : ${dateTime.difference(DateTime.now()).inDays} روز \nدانلود های باقی مانده: ${downloadMax - userDownloaded}";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: const Icon(Icons.arrow_forward_ios),
          // ),
          body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Gap(10),
                  Image.asset(
                    'assets/images/icon.png',
                    height: 40,
                  ),
                  const Gap(10),
                  const MyText(
                    txt: 'پروفایل',
                    size: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close)),
                  const Gap(10),
                ],
              ),
              const Gap(10),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Color(0xFF00224D)),
                child: Column(
                  children: [
                    // const Gap(10),
                    Row(
                      children: [
                        const Gap(10),
                        InkWell(
                          onTap: () {
                            Get.toNamed(
                              PhotoViewer.routeName,
                              arguments: {
                                'heroTag': Utils().getProfileData().pic ?? "",
                                'photoUrl': Utils().getProfileData().pic ?? ""
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                Utils().getProfileData().pic != null
                                    ? NetworkImage(
                                        Utils().getProfileData().pic ?? "")
                                    : const AssetImage('assets/images/icon.png')
                                        as ImageProvider,
                          ),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(30),
                            MyText(
                              txt:
                                  ("${Utils().getProfileData().fullName ?? ""}  ${Utils().getProfileData().lastName ?? ""}"),
                              size: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            MyText(
                              txt: Utils().getProfileData().userAuth ?? "",
                              color: Colors.grey,
                              size: 14,
                            ),
                            const Gap(10),
                            MyText(
                              txt: userStatusLabel(),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              await Get.to(() => const EditProfileScreen());

                              setState(() {});
                            },
                            icon: const Icon(Iconsax.edit)),
                        const Gap(20),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     const Gap(80),
                    //   ],
                    // ),
                    // const Divider(
                    //   color: Colors.white,
                    //   thickness: .4,
                    // ),
                    const Gap(10),
                    SettingItems(
                      icon: Iconsax.add_circle,
                      title: 'خرید (تمدید) اشتراک',
                      onTap: () async {
                        await Get.to(() => const PlanScreen());
                        setState(() {});
                      },
                    ),
                    const Gap(10),
                    SettingItems(
                      icon: Iconsax.devices_1,
                      title: "افزودن دستگاه",
                      onTap: () async {
                        AddDeviceController().call();
                      },
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: .4,
                    ),
                    const Gap(10),
                    SettingItems(
                      onTap: () {
                        Get.to(() => SupportPage());
                      },
                      icon: Iconsax.support,
                      title: 'ارتباط با پشتیبانی',
                    ),
                    SettingItems(
                      onTap: () {
                        Get.to(() => const CriticismPage());
                      },
                      icon: Iconsax.video,
                      title: 'درخواست افزودن فیلم',
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: .4,
                    ),
                    const Gap(10),
                    SettingItems(
                      onTap: () {
                        Get.to(() => const LastPlayerScreen());
                      },
                      icon: Iconsax.clock,
                      title: 'مشاهده شده ها',
                    ),
                    SettingItems(
                      onTap: () {
                        Get.to(() => const SavedVideoScreen(page: "favorite"));
                      },
                      icon: Iconsax.heart,
                      title: 'علاقه مندی ها',
                    ),
                    SettingItems(
                      onTap: () {
                        Get.to(() => const SavedVideoScreen(page: "bookmark"));
                      },
                      icon: Iconsax.bookmark,
                      title: 'لیست های من',
                    ),
                    if ((GetStorageData.getData("user_logined") ?? false) !=
                        false)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            GeneralDialog.show(
                                context, 'خروج', 'آیا مطمئن هستید؟', 'بله',
                                () async {
                              await GetStorageData.clear();
                              Get.offAll(const Splash());
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: MyText(
                              txt: 'خروج از حساب',
                            ),
                          ),
                        ),
                      ),
                    const Text("version: 1.3.83-release"),
                    const Gap(10)
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
