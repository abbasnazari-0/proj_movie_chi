import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_series_movies/presentations/controllers/movies_controller.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../core/models/search_video_model.dart';
import '../../../feature_home/presentation/widgets/search_shimmer.dart';
import '../../../feature_search/presentation/widgets/custom_footer_refresh.dart';
import '../../../feature_search/presentation/widgets/search_screen_item.dart';

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MvoiesController>(builder: (controller) {
      if (controller.pageStatus == PageStatus.error) {
        return const Center(
          child: Text("Error"),
        );
      }
      return SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: controller.refreshController,
        footer: const RefreshCustomWidget(),
        onLoading: () {
          controller.getMovies(false);
        },
        child: (controller.pageStatus == PageStatus.loading)
            ? const SearchShimmer()
            : GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: MediaQuery.of(context).size.height * 0.25,
                    crossAxisCount: 3),
                itemCount: controller.movies.length,
                itemBuilder: (BuildContext context, int index) {
                  SearchVideo item = controller.movies[index];
                  return SearchItem(item: item);
                },
              ),
      );
    });
  }
}
