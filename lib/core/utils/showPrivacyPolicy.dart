import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/mytext.dart';
import 'get_storage_data.dart';

showPrivacyDialog() {
  showDialog(
    context: Get.context!,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        bool isPrivacy = GetStorageData.getData("privacy") ?? false;
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Theme.of(Get.context!).primaryColor,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const MyText(
                        txt: "قوانین استفاده از اپلیکیشن",
                        size: 22,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 30),
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(children: [
                            MyText(
                                txt:
                                    ("""برنامه مووی چی! در نظر دارد تا به کاربران امکان دسترسی به فیلم‌ها و سریال‌ها را بدهد. با این حال، ما به صراحت اعلام می‌کنیم که این برنامه برای استفاده توسط افراد زیر 18 سال مناسب نیست.
            
            استفاده از برنامه
            با استفاده از برنامه مووی چی!، شما تایید می‌کنید که 
            
            شما حداقل 18 سال سن دارید 
            
            شما قوانین محلی، منطقه‌ای، و بین‌المللی خود را احترام می‌گذارید و این برنامه را به طور قانونی استفاده می‌کنید
            
            شما متوجه هستید که برخی از محتوای در دسترس در مووی چی! ممکن است برای برخی افراد نامناسب باشد، و شما برای مشاهده چنین محتوایی مسئولیت می‌پذیرید.
            
            شما متوجه هستید که ما نمی‌توانیم تضمین کنیم که تمام محتوا به طور کامل سانسور شده و/یا مجوز فراهم کرده است.
            
            
            تخلفات: 
            اگر ما متواجد کنیم که شما در حال نقض این خط مشی یا قوانین محلی، منطقه‌ای، یا بین‌المللی خود هستید، ما حق داریم که دسترسی شما را به برنامه مووی چی! محدود یا مسدود کنیم.
            
            """),
                                size: 16,
                                textAlign: TextAlign.right),
                            SizedBox(height: 30),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    // checkbox
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: CheckboxListTile(
                        value: GetStorageData.getData("privacy") ?? false,
                        title: const MyText(
                          txt: "من قوانین را می پذیرم",
                          size: 16,
                        ),
                        checkColor:
                            Theme.of(context).badgeTheme.backgroundColor,
                        activeColor:
                            Theme.of(Get.context!).colorScheme.secondary,
                        onChanged: (value) {
                          GetStorageData.writeData("privacy", value);
                          setState(() {});
                          // Get.back();
                        },
                      ),
                    ),
                    // submit button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isPrivacy) {
                              Get.back();
                            } else {
                              Get.snackbar("", "",
                                  snackPosition: SnackPosition.BOTTOM,
                                  messageText: const MyText(
                                    txt: "لطفا قوانین را مطالعه کنید",
                                    size: 16,
                                    color: Colors.white,
                                    textAlign: TextAlign.center,
                                  ),
                                  titleText: const MyText(
                                    txt: "خطا",
                                    size: 16,
                                    color: Colors.white,
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(20),
                                  padding: const EdgeInsets.all(20));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(Get.context!).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const MyText(
                            txt: "تایید و ورود",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}
