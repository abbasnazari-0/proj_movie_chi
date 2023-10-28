import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/widgets/mytext.dart';
import '../../controllers/detail_page_controller.dart';

class DubbleOSubtitle extends StatelessWidget {
  const DubbleOSubtitle({
    super.key,
    required this.pageController,
  });

  final DetailPageController pageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if ((pageController.videoDetail?.dubble ?? "0") == "1")
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: ((pageController.videoDetail?.dubble ?? "0") == "1")
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Iconsax.microphone),
                            MyText(
                              txt: "دوبله فارسی",
                              color: Colors.white,
                            )
                          ],
                        )
                      : Container(),
                ),
              ),
            if ((pageController.videoDetail?.subtitle ?? "0") == "1")
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  height: 40,
                  child: ((pageController.videoDetail?.subtitle ?? "0") == "1")
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Iconsax.subtitle),
                            MyText(
                              txt: "زیرنویس فارسی",
                              color: Colors.white,
                            )
                          ],
                        )
                      : Container(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
