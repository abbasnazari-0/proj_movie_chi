import 'package:get/get.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/page_status.dart';

import '../../../../core/models/search_video_model.dart';
import '../../domain/usecases/home_catagory_usecase.dart';

class BookMarkScreenController extends GetxController {
  final HomeCatagoryUseCase homeCatagoryUseCase;
  BookMarkScreenController(this.homeCatagoryUseCase, this.page);

  var bookMarkList = <SearchVideo>[];
  var favoriteList = <SearchVideo>[];
  PageStatus pageStatus = PageStatus.loading;
  final String page;

  @override
  void onInit() {
    super.onInit();
    if (page == "bookmark") {
      getBookMarkList();
    } else {
      getFavoriteList();
    }
    // getBookMarkList();
  }

  void getBookMarkList() async {
    DataState dataState = await homeCatagoryUseCase
        .getBookmarkedVideo(GetStorageData.getData('user_tag'));
    if (dataState is DataSuccess) {
      bookMarkList = dataState.data;
      pageStatus = PageStatus.success;
      update();
    }
    if (dataState is DataFailed) {
      pageStatus = PageStatus.error;
      // print(dataState.error);
    }
  }

  void getFavoriteList() async {
    DataState dataState = await homeCatagoryUseCase
        .getFavoriteVideo(GetStorageData.getData('user_tag'));
    if (dataState is DataSuccess) {
      bookMarkList = dataState.data;

      pageStatus = PageStatus.success;
      update();
    }
    if (dataState is DataFailed) {
      pageStatus = PageStatus.error;
      // print(dataState.error);
    }
  }

  removeBookMark(int index) {
    bookMarkList.removeAt(index);
    update();
  }
}
