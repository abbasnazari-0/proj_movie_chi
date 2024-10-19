import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/models/search_video_model.dart';
import 'package:movie_chi/core/utils/convert_to_decimal_number.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/my_text_field.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/tv_controller/search_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/search_shimmer.dart';
import 'package:movie_chi/features/feature_search/presentation/controller/search_page_controller.dart';
import 'package:movie_chi/features/feature_search/presentation/widgets/custom_footer_refresh.dart';
import 'package:movie_chi/features/feature_search/presentation/widgets/custome_keyboard_tv.dart';
import 'package:movie_chi/features/feature_search/presentation/widgets/empty_search_page.dart';
import 'package:movie_chi/features/feature_search/presentation/widgets/empty_search_screen.dart';
import 'package:movie_chi/features/feature_search/presentation/widgets/search_screen_item.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class SearchTVPage extends StatelessWidget {
  const SearchTVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AndroidTvSearchController>(
        init: AndroidTvSearchController(),
        builder: (controller) {
          return Container(
            color: Colors.black54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.showKeyboard == true)
                  Expanded(
                      child: SizedBox(
                          height: MediaQuery.of(Get.context!).size.height * 0.7,
                          child: const CustomKeyboard())),
                Center(
                  child: Center(
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (value) async {
                        if (controller.itemIndex >= 10) {
                          await controller.keyboardController(value);
                        } else if (controller.itemIndex <= 1) {
                          if (controller.itemIndex < 0.00) {
                            controller.itemIndex = 0.01;
                            controller.update();
                          }
                          if (controller.isUpdating) return;
                          controller.isUpdating = true;
                          if (value.logicalKey ==
                              LogicalKeyboardKey.arrowRight) {
                            controller.itemIndex = controller.itemIndex - 0.01;
                          } else if (value.logicalKey ==
                              LogicalKeyboardKey.arrowLeft) {
                            controller.itemIndex = controller.itemIndex + 0.01;
                            // controller.update();
                          } else if (value.logicalKey ==
                              LogicalKeyboardKey.arrowDown) {
                            if (controller.itemIndex >= 0.02) {
                              controller.itemIndex =
                                  controller.itemIndex + 0.05;
                            } else if (controller.itemIndex <= 0.02) {
                              controller.itemIndex =
                                  controller.itemIndex + 0.01;
                            }

                            // controller.update();
                          } else if (value.logicalKey ==
                              LogicalKeyboardKey.arrowUp) {
                            if (controller.itemIndex > 0.02) {
                              controller.itemIndex =
                                  controller.itemIndex - 0.05;
                            } else if (controller.itemIndex <= 0.02) {
                              controller.itemIndex =
                                  controller.itemIndex - 0.01;
                            }
                          }

                          if (controller.itemIndex < 0.00) {
                            controller.itemIndex = 0.00;
                            controller.update();
                          }

                          if (controller.itemIndex >= 0.02) {
                            if (controller.itemIndex <= 0.07) {
                              controller.searchScrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              double value = 0;

                              value = ((controller.itemIndex + 0.03) *
                                  100 /
                                  4 *
                                  150);

                              controller.searchScrollController.animateTo(
                                value,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                              );
                              // }
                            }
                          }
                          controller.itemIndex = double.parse(
                              controller.itemIndex.toStringAsFixed(2));
                          controller.update();

                          await Future.delayed(
                              const Duration(milliseconds: 200));
                          controller.isUpdating = false;
                          // controller.prevIndex = controller.itemIndex;

                          if (value.logicalKey == LogicalKeyboardKey.enter) {
                            controller.onClicked();
                            controller.searchScrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            );
                          }
                        } else {
                          if (controller.itemIndex < 0.00) {
                            controller.itemIndex = 0.00;
                            controller.update();
                          } else if (controller.itemIndex <= 10.00) {
                            controller.itemIndex = 10.00;
                            controller.update();
                          } else {}
                        }
                        // debugPrint(controller.itemIndex.toString());
                      },
                      child: Column(
                        children: [
                          Gap(MediaQuery.sizeOf(Get.context!).height * 0.1),
                          controller.indexingWidget(
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              0.0),
                          const Gap(20),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20)),
                            height: 80,
                            width: MediaQuery.of(Get.context!).size.width * 0.6,
                            child: Material(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  const Gap(20),
                                  Expanded(
                                    child: controller.indexingWidget(
                                        MyTextField(
                                          textEditingController:
                                              controller.searchController,
                                          enabled: false,
                                          borderColor: Colors.white,
                                          prefixIcon: Icons.close,
                                          onChanged: (text) {
                                            controller.startSearch();
                                          },
                                        ),
                                        0.01),
                                  ),
                                  const Gap(20),
                                ],
                              ),
                            ),
                          ),
                          const Gap(20),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(20)),
                              width:
                                  MediaQuery.of(Get.context!).size.width * 0.5,
                              child: Material(
                                color: Colors.transparent,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: GetBuilder<SearchPageController>(
                                    builder: (searchController) {
                                      if (searchController.searchPageStatus ==
                                          PageStatus.empty) {
                                        return const EmptyPage();
                                      }
                                      if (searchController
                                              .searchData.data!.isEmpty &&
                                          searchController.searchPageStatus ==
                                              PageStatus.error) {
                                        return const SearchEmptyScreen();
                                      } else {
                                        return SmartRefresher(
                                          enablePullDown: false,
                                          enablePullUp: true,
                                          controller:
                                              controller.refreshController,
                                          footer: const RefreshCustomWidget(),
                                          onLoading: () {
                                            searchController.onstartLoadSearch(
                                                false,
                                                withChangePage: false,
                                                refreshController: controller
                                                    .refreshController);
                                          },
                                          child:
                                              (searchController
                                                          .searchPageStatus ==
                                                      PageStatus.loading)
                                                  ? const SearchShimmer()
                                                  : GridView.builder(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                          mainAxisExtent:
                                                              MediaQuery.of(Get
                                                                          .context!)
                                                                      .size
                                                                      .height *
                                                                  0.20,
                                                          crossAxisCount: 3),
                                                      itemCount:
                                                          searchController
                                                              .searchData
                                                              .data
                                                              ?.length,
                                                      controller: controller
                                                          .searchScrollController,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        SearchVideo item =
                                                            searchController
                                                                .searchData
                                                                .data![index];
                                                        return controller
                                                            .indexingWidget(
                                                                SearchItem(
                                                                  item: item,
                                                                ),
                                                                double.parse((double.parse(
                                                                            "0.") +
                                                                        convertToDecimal(
                                                                            index +
                                                                                2))
                                                                    .toStringAsFixed(
                                                                        2)));
                                                      },
                                                    ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Gap(20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
