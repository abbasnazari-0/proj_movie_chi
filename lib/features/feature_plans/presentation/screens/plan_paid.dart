import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_plans/presentation/controllers/plan_controller.dart';

class PlanPaid extends StatefulWidget {
  const PlanPaid({super.key});

  @override
  State<PlanPaid> createState() => _PlanPaidState();
}

class _PlanPaidState extends State<PlanPaid> {
  final controller = Get.find<PlanScreenController>();
  @override
  void initState() {
    controller.checkUserPlan();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GetStorageData.writeData("plan_viewed", false);
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 30, right: 20),
            child: FloatingActionButton(
              onPressed: () {
                Get.back();
              },
              backgroundColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              child: Icon(Iconsax.arrow_right_14,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: GetBuilder<PlanScreenController>(builder: (controller) {
            if (controller.paidPageStatus == PageStatus.loading) {
              return Center(
                  child: LoadingAnimationWidget.flickr(
                size: 50,
                leftDotColor: Get.theme.colorScheme.secondary,
                rightDotColor:
                    Get.theme.colorScheme.background.withOpacity(0.5),
              ));
            }
            return Stack(
              children: [
                ConfettiWidget(
                  confettiController: controller.controllerCenter,

                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                      true, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                  createParticlePath:
                      controller.drawStar, // define a custom shape/path.
                ),
                Center(
                  child: Column(
                    children: [
                      Lottie.asset("assets/lotties/premium.json",
                          height: size.height * 0.3),
                      MyText(
                        txt: controller.isPremium ? "مبارکه" : "پریمیوم نشدی",
                        size: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        child: MyText(
                          txt: controller.isPremium
                              ? "با موفقیت پریموم شدی!"
                              : "اکانتت هنوز پریمیوم نشد",
                          size: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade100,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: MyText(
                              txt: 'برگشت به برنامه',
                              color: Color(0xff17181b),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
