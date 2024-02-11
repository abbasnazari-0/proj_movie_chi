import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/params/search_params.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
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
  RxInt page = 1.obs;
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
    if (suggestionList.isNotEmpty) {
      suggestionList.insert(0, 'حذف تاریخچه');
    }
    // suggestionList = ["hello", "how", "are", "you"];
    update();
  }

  removeSearchHisotry(context) {
    Get.defaultDialog(
      title: 'حذف تاریخچه جستجو',
      content: const MyText(
        txt: 'آیا از حذف تاریخچه خود مطمئن هستید؟',
      ),
      cancel: OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const MyText(txt: 'خیر')),
      confirm: FilledButton(
          onPressed: () {
            GetStorageData.writeData("hisstory", []);
            Navigator.pop(context);
            Constants.showGeneralSnackBar(
                'تاریخچه حذف شد', "با موفقیت تاریخچه جستجو حذف شد");
          },
          child: const MyText(txt: 'بله')),
    );
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

    // if (controller.text.isEmpty) {
    //   searchPageStatus = PageStatus.empty;
    //   update();
    //   searchData = [];
    //   return;
    // }
    if (withChangePage) {
      // bottomAppBarController.chnageItemSelected(2.obs);
      // bottomAppBarController.chnagePageViewSelected(2.obs);
    }

    if (withremoving) {
      searchData.clear();
      page = 1.obs;
    } else {
      page++;
    }
    if (withChangePage) {
      searchPageStatus = PageStatus.loading;
    }
    update();

    DataState dataState = await searchUseCase.call(SearchParamsQuery(
        query: controller.text,
        count: page.value,
        imdb: searchBarCont.imdbSelected,
        type: searchBarCont.typeSelected,
        year: searchBarCont.yearSelected,
        zhanner: searchBarCont.zhannerSelected,
        advancedQuery: searchBarCont.advancedFilter));

    if (dataState is DataSuccess) {
      if (withremoving) {
        searchData = dataState.data;
      } else {
        searchData.addAll(dataState.data);
      }
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
