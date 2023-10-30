import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/page_status.dart';
import '../../data/models/movies_serias_type_show.dart';
import '../../domain/usecases/serias_movies_use_cases.dart';

class SeriasController extends GetxController {
  SeriasMoviesUseCases seriasMoviesUseCases;
  SeriasController({
    required this.seriasMoviesUseCases,
  });

  @override
  void onInit() {
    super.onInit();
    getSerias(false);
    getTypeShow();
  }

  String showType = "";
  RefreshController refreshController = RefreshController();
  HomeCatagory? homeCatagory;
  String searchQ = "";
  List<TypeShow> typeShow = [
    //add all
    TypeShow(typeShow: "all", typeShowTitle: "همه"),
  ];
  int pages = -1;
  TextEditingController searchController = TextEditingController();
  PageStatus pageStatus = PageStatus.loading;

  getSerias(bool withUpdate) async {
    if (withUpdate) {
      pages = 0;
      // searis.clear();
      pageStatus = PageStatus.loading;

      update();
    } else {
      pages++;
      // refreshController.requestLoading();
    }
    DataState data =
        await seriasMoviesUseCases.getSerias(pages, showType, searchQ);

    if (data is DataSuccess) {
      if (homeCatagory == null) {
        homeCatagory = data.data;
      } else {
        HomeCatagory newHomeCatagory = data.data;
        homeCatagory?.data?.data?.addAll(newHomeCatagory.data!.data!);
      }

      // searis.addAll(data.data);
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
