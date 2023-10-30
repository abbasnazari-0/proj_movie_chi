import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';
import 'package:movie_chi/features/feature_series_movies/domain/usecases/serias_movies_use_cases.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../data/models/movies_serias_type_show.dart';

class MvoiesController extends GetxController {
  SeriasMoviesUseCases seriasMoviesUseCases;

  RefreshController refreshController = RefreshController();
  List<TypeShow> typeShow = [TypeShow(typeShow: "all", typeShowTitle: "همه")];
  String showType = "";
  String searchQ = "";
  @override
  void onInit() {
    super.onInit();
    getMovies(false);
    getTypeShow();
  }

  // List<SearchVideo> movies = [];
  HomeCatagory? homeCatagory;
  MvoiesController({required this.seriasMoviesUseCases});
  TextEditingController searchController = TextEditingController();
  PageStatus pageStatus = PageStatus.loading;
  int page = -1;

  getMovies(bool withUpdate) async {
    if (withUpdate) {
      page = 0;
      // movies.clear();
      homeCatagory = null;
      pageStatus = PageStatus.loading;
      update();
    } else {
      page++;
    }

    DataState data =
        await seriasMoviesUseCases.getMovies(page, showType, searchQ);
    if (data is DataSuccess) {
      if (homeCatagory == null) {
        homeCatagory = data.data;
      } else {
        HomeCatagory newHomeCatagory = data.data;
        homeCatagory?.data?.data?.addAll(newHomeCatagory.data!.data!);
      }
      pageStatus = PageStatus.success;
      update();
    }
    if (data is DataFailed) {
      debugPrint(data.error);
      pageStatus = PageStatus.error;
      update();
    }
    refreshController.loadComplete();
  }

  getTypeShow() async {
    DataState dataState = await seriasMoviesUseCases.getTypeShows();
    if (dataState is DataSuccess) {
      typeShow = dataState.data;
      update();
    }
    if (dataState is DataFailed) {
      debugPrint(dataState.error);
    }
  }
}
