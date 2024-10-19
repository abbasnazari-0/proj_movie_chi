import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/utils/convert_to_decimal_number.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/tv_controller/search_controller.dart';

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({super.key});

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  // حروف زبان انگلیسی

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: false,
      canRequestFocus: false,
      child: GetBuilder<AndroidTvSearchController>(builder: (controller) {
        return Container(
          // height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            border: Border.all(color: Colors.white),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  controller.indexingWidget(
                      ElevatedButton(
                        autofocus: false,
                        onPressed: () {
                          setState(() {
                            controller.isEnglish =
                                !controller.isEnglish; // تغییر زبان
                          });
                        },
                        child: Text(controller.isEnglish ? 'فا' : 'EN'),
                      ),
                      10.0),
                  controller.indexingWidget(
                    ElevatedButton(
                      autofocus: false,
                      onPressed: () {
                        // عملکرد فاصله
                      },
                      child: const Icon(Icons.space_bar),
                    ),
                    10.01,
                  ),
                  controller.indexingWidget(
                    ElevatedButton(
                      autofocus: false,
                      onPressed: () {
                        // عملکرد حذف
                      },
                      child: const Icon(Icons.backspace),
                    ),
                    10.02,
                  ),
                  controller.indexingWidget(
                    ElevatedButton(
                      autofocus: false,
                      onPressed: () {
                        Get.back();
                        // عملکرد فاصله
                      },
                      child: const Icon(Icons.close),
                    ),
                    10.03,
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, // تعداد ستون‌ها
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 20,
                  ),
                  itemCount: controller.isEnglish
                      ? controller.englishKeys.length
                      : controller.persianKeys.length,
                  itemBuilder: (context, index) {
                    String keyLabel = controller.isEnglish
                        ? controller.englishKeys[index]
                        : controller.persianKeys[index];
                    return controller.indexingWidget(
                        TextButton(
                          autofocus: false,
                          onPressed: () {
                            // عملکرد کلیک روی هر دکمه
                          },
                          child: Text(keyLabel,
                              style: const TextStyle(fontSize: 18)),
                        ),
                        double.parse(
                            (double.parse("10.") + convertToDecimal(index + 4))
                                .toStringAsFixed(2)));
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
