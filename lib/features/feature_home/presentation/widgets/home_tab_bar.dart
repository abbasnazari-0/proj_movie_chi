import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

import '../../data/model/home_catagory_model.dart';
import '../controller/home_page_controller.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar(
      {Key? key,
      required this.width,
      this.onSelectedTab,
      required this.tabBar,
      required this.homePageController})
      : super(key: key);

  final double width;
  final Function(int value)? onSelectedTab;
  final List<HomeCatagoryData> tabBar;
  final HomePageController homePageController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabBar.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  onSelectedTab!(index);
                },
                child: Column(
                  children: [
                    GetBuilder<HomePageController>(
                      builder: (controller) => AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        child: MyText(
                          // txt: tabBar[index].title!,
                          color: controller.tabSelected == index
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context)
                                  .primaryTextTheme
                                  .bodyMedium!
                                  .color,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    GetBuilder<HomePageController>(builder: (controller) {
                      return Container(
                        height: 1,
                        color: controller.tabSelected == index
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.transparent,
                        width: width * 0.10,
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
