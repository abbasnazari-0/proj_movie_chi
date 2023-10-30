import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/mytext.dart';
import '../../../../locator.dart';
import '../controllers/movies_controller.dart';

class FilmHeader extends StatelessWidget {
  FilmHeader({
    super.key,
  });

  final filmController =
      Get.put(MvoiesController(seriasMoviesUseCases: locator()));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          // Expanded(
          //   child: ArtistSearchBox(
          //     searchController: filmController.searchController,
          //     size: MediaQuery.of(context).size,
          //     onChanegd: () {
          //       if (filmController.searchController.text.isEmpty) {
          //         filmController.searchQ = "";

          //         filmController.getMovies(true);
          //       }
          //     },
          //     onSubmited: (value) {
          //       filmController.searchQ = filmController.searchController.text;

          //       filmController.getMovies(true);
          //     },
          //     onClosed: () {
          //       filmController.searchQ = "";
          //       filmController.getMovies(true);
          //     },
          //   ),
          // ),
          GetBuilder<MvoiesController>(builder: (controller) {
            return PopupMenuButton(
                icon: const Icon(Icons.filter_list),
                tooltip: "بر اساس",
                color: Theme.of(context).colorScheme.background,
                constraints: const BoxConstraints(
                  minWidth: 300,
                ),
                onSelected: (value) {
                  controller.showType = value as String;
                  controller.getMovies(true);
                },
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
