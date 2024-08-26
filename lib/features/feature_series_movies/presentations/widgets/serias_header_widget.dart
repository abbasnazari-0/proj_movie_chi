import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/locator.dart';

import '../../../../core/widgets/mytext.dart';

import '../controllers/seriase_controller.dart';

class SeriasHeader extends StatelessWidget {
  SeriasHeader({
    super.key,
  });

  final filmController =
      Get.put(SeriasController(seriasMoviesUseCases: locator()));
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          GetBuilder<SeriasController>(builder: (controller) {
            return PopupMenuButton(
                icon: const Icon(Icons.filter_list),
                onSelected: (value) {
                  controller.showType = value as String;
                  controller.getSerias(true);
                },
                tooltip: "بر اساس",
                color: Theme.of(context).colorScheme.background,
                constraints: const BoxConstraints(
                  minWidth: 300,
                ),
                elevation: 20,
                splashRadius: 50,
                itemBuilder: (context) {
                  return controller.typeShow
                      .map((e) => PopupMenuItem(
                            value: e.typeShow,
                            child: MyText(
                              txt: e.typeShowTitle ?? "",
                            ),
                          ))
                      .toList();
                });
          }),
        ],
      ),
    );
  }
}
