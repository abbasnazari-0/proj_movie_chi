import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:movie_chi/core/models/search_video_model.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/page_status.dart';

import '../../data/models/artist_data_model.dart';
import '../../domain/usecase/artist_page_usecase.dart';

class ArtistListController extends GetxController {
  ArtistPageUseCases homeCatagoryUseCase;
  ArtistListController({required this.homeCatagoryUseCase});
  PageStatus pageStatus = PageStatus.loading;
  PageStatus pageStatus2 = PageStatus.loading;

  List<SearchVideo> artistVideoData = [];
  int artistVideoPage = -1;
  String? artistName;
  String? artistTag;

  List<ArtistItemData> artistData = [];
  int artistPage = -1;

  TextEditingController searchController = TextEditingController();
  bool isFocused = false;

  changeFocus(bool value) {
    isFocused = value;
    update();
  }

  getArtistSuggestions(RefreshController? refrehController) async {
    artistPage++;
    pageStatus = PageStatus.loading;

    if (refrehController != null) refrehController.requestLoading();
    DataState dataState = await homeCatagoryUseCase.getArtistSuggestionData(
        20, artistPage, artistName, artistTag);
    if (dataState is DataSuccess) {
      if (dataState.data.isEmpty) {
        pageStatus = PageStatus.empty;
        update();
        return;
      }
      pageStatus = PageStatus.success;
      artistData.addAll(dataState.data);
      update();
      if (refrehController != null) refrehController.loadComplete();
    } else {
      pageStatus = PageStatus.error;

      if (refrehController != null) refrehController.loadFailed();
    }
  }

  getArtistData(RefreshController? refrehController,
      ArtistItemData artistItemData) async {
    artistVideoPage++;
    pageStatus2 = PageStatus.loading;

    if (refrehController != null) refrehController.requestLoading();
    DataState dataState = await homeCatagoryUseCase.getArtistData(20,
        artistVideoPage, artistItemData.artistName, artistItemData.artistTag);
    if (dataState is DataSuccess) {
      if (dataState.data.isEmpty) {
        pageStatus2 = PageStatus.empty;
        update();
        return;
      }
      pageStatus2 = PageStatus.success;

      artistVideoData.addAll(dataState.data);
      update();
      if (refrehController != null) refrehController.loadComplete();
    } else {
      pageStatus2 = PageStatus.error;

      if (refrehController != null) refrehController.loadFailed();
    }
  }
}
