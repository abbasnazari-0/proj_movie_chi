import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/params/search_params.dart';
import 'package:movie_chi/features/feature_search/presentation/controller/home_searchbar_controller.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_search/domain/usecases/search_usecase.dart';

import '../../../feature_home/presentation/controller/bottom_app_bar_controller.dart';
import '../../../../core/models/search_video_model.dart';

class SearchPageController extends GetxController {
  final SearchUseCase searchUseCase;
  RxInt itemCount = 15.obs;
  PageStatus searchPageStatus = PageStatus.empty;

  TextEditingController controller = TextEditingController();
  final bottomAppBarController =
      Get.put<BottomAppBarController>(BottomAppBarController());
  SearchPageController(this.searchUseCase);

  List<SearchVideo> searchData = [];
  bool searchFouceMode = false;
  List suggestionList = [];
  SuggestionsBoxController suggestionsBoxController =
      SuggestionsBoxController();

  getSearchHisotry() {
    suggestionList = GetStorageData.getData("hisstory") ?? [];
    suggestionList = List.from(suggestionList.reversed);

    // suggestionList = ["hello", "how", "are", "you"];
    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    onstartLoadSearch(true, withChangePage: false);
    update();
  }

  onSearchBoxFocusing(bool focusMode) {
    searchFouceMode = focusMode;
    update();
  }

  onstartLoadSearch(bool withremoving,
      {withChangePage = true, RefreshController? refreshController}) async {
    final searchBarCont =
        Get.put<HomeSearchBarController>(HomeSearchBarController());

    if (controller.text.isEmpty) {
      searchPageStatus = PageStatus.empty;
      update();
      searchData = [];
      return;
    }
    if (withChangePage) {
      // bottomAppBarController.chnageItemSelected(2.obs);
      // bottomAppBarController.chnagePageViewSelected(2.obs);
    }

    if (withremoving) {
      searchData.clear();
      itemCount = 15.obs;
    } else {
      itemCount = itemCount + 15;
    }
    if (withChangePage) {
      searchPageStatus = PageStatus.loading;
    }
    update();

    DataState dataState = await searchUseCase.call(SearchParamsQuery(
        query: controller.text,
        count: itemCount.value,
        imdb: searchBarCont.imdbSelected,
        type: searchBarCont.typeSelected,
        year: searchBarCont.yearSelected,
        zhanner: searchBarCont.zhannerSelected,
        advancedQuery: searchBarCont.advancedFilter));

    if (dataState is DataSuccess) {
      searchData = dataState.data;
      refreshController?.loadComplete();

      searchPageStatus = PageStatus.success;

      update();
    }
    if (dataState is DataFailed) {
      if (dataState.error.toString().contains('not found')) {
        searchPageStatus = PageStatus.empty;
        refreshController?.loadNoData();
      } else {
        searchPageStatus = PageStatus.error;
        refreshController?.loadFailed();
      }
      update();
    }
  }
}
