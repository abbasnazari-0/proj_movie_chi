import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/lauch_url.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/divider_with_text.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_plans/presentation/controllers/plan_controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final controller = Get.find<PlanScreenController>();

  @override
  void dispose() {
    controller.checkAndGo();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.getPlans();
    controller.checkAndGo();
    controller.monthly = false;
  }

  @override
  Widget build(BuildContext context) {
    GetStorageData.writeData("plan_viewed", true);
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
                Navigator.pop(context);
              },
              backgroundColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              child: Icon(Iconsax.arrow_right_14,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: GetBuilder<PlanScreenController>(builder: (controller) {
            if (controller.pageStatus == PageStatus.loading) {
              return Center(
                  child: LoadingAnimationWidget.flickr(
                size: 50,
                leftDotColor: Get.theme.colorScheme.secondary,
                rightDotColor:
                    Get.theme.colorScheme.background.withOpacity(0.5),
              ));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Lottie.asset("assets/lotties/premium.json",
                      height: size.height * 0.3),
                  MyText(
                    txt: controller.plan.title ?? "",
                    size: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: MyText(
                      txt: controller.plan.desc ?? "",
                      size: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade100,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DividerWithText(
                      horizontalPadding: size.width * 0.2, text: "پلن ها"),
                  Gap(size.height * 0.02),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const MyText(
                      txt: "ماهانه",
                    ),
                    const Gap(10),
                    Switch(
                      onChanged: (bool montlyMode) {
                        controller.changeMonthlyStatus(montlyMode);
                      },
                      value: controller.monthly,
                    ),
                    const Gap(10),
                    const MyText(
                      txt: "سه ماهه",
                    ),
                  ]),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => PlanItem(index: index),
                    itemCount: controller.plan.data?.length,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: MyText(
                      txt:
                          "نوت : پس از پرداخت لطفا برنامه را کامل ببنید و باز کنید",
                      size: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade100,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class PlanItem extends StatelessWidget {
  PlanItem({super.key, required this.index});
  final int index;
  final controller = Get.find<PlanScreenController>();

  double calculatePercentageDifference(double price1, double price2) {
    double difference = price1 - price2;
    double percentage = difference / price1 * 100;
    return percentage;
  }

  String downloadMaxToString(String count) {
    if (count == "-1") {
      return "∞";
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      splashColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        mlaunchUrl(
            "${dotenv.env['CONST_URL'] ?? ""}/v9/payment/request.php?type=${controller.plan.data![index].id}&token=${GetStorageData.getData("user_tag")}");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: size.width * 0.1),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(99),
                          topRight: Radius.circular(99))),
                  height: 25,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MyText(
                      txt: controller.plan.data![index].planTitle ?? "",
                      textAlign: TextAlign.center),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white.withOpacity(0.15),
                        blurRadius: 5,
                        offset: const Offset(0, 3))
                  ],
                  border: controller.plan.data![index].planSelected == "1"
                      ? Border.all(
                          color: Colors.white.withAlpha(150),
                          width: 2,
                          style: BorderStyle.solid)
                      : null,
                  color: Theme.of(context).colorScheme.background),
              height: 65,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            RichText(
                              softWrap: false,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: controller.plan.data![index].planPrice
                                        .toString()
                                        .seRagham(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: size.width * 0.01),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(999)),
                              height: 20,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: MyText(
                                txt:
                                    "${calculatePercentageDifference(double.parse(controller.plan.data![index].planPrice ?? "80.0"), double.parse(controller.plan.data![index].planPriceOff ?? "0.0")).toStringAsFixed(0)}%",
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        MyText(
                          txt:
                              "${controller.plan.data![index].planPriceOff.toString().seRagham()} تومان",
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          txt:
                              "${downloadMaxToString(controller.plan.data![index].planDownMax ?? "80.0")} ${controller.monthly ? "دانلود در سه ماه" : "دانلود در ماه"}",
                        ),
                        const MyText(
                          txt: "تماشای نامحدود فیلم و سریال و انیمیشن",
                          size: 10,
                          color: Colors.green,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
