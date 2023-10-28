import 'dart:convert';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_play_list/domain/usecases/play_list_usecase.dart';

import '../../../../core/params/play_list_params.dart';
import '../../data/model/play_list_model.dart';

class PlayListController extends GetxController {
  final PlayListUseCase useCase;
  String type = "";
  String playListId = "";
  int amount = 20;
  String keyWord = "";

  PlayListController(this.useCase);
  PageStatus pageStatus = PageStatus.loading;
  PlayListModel? playListModel;
  convertModelToListIds(PlayListModel playListModel) {
    List videoIDS = [];
    for (var element in playListModel.data!) {
      videoIDS.add(element.id);
    }
    return videoIDS;
  }

  loadPlayListData({bool withLoad = false}) async {
    List videoIDS = [];
    if (playListModel != null && playListModel!.data!.isNotEmpty) {
      videoIDS = convertModelToListIds(playListModel ?? PlayListModel());
    }

    if (withLoad == false) {
      amount = 20;
      pageStatus = PageStatus.loading;
      update();
    } else {
      amount += 20;
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    DataState dataState = await useCase.getPlayList(PlayListParams(
      version: packageInfo.version,
      playListId: playListId,
      playListType: type,
      keyWord: keyWord,
      videoIds: json.encode(videoIDS.toString()),
    ));
    if (dataState is DataSuccess) {
      PlayListModel playListModel2 = dataState.data;

      if ((playListModel2.data?.isEmpty ?? true) && playListModel == null) {
        pageStatus = PageStatus.empty;
        update();
        return;
      }

      if (playListModel == null) {
        playListModel = playListModel2;
      } else {
        playListModel!.data!.addAll(playListModel2.data!);
      }

      pageStatus = PageStatus.success;
    } else if (dataState is DataFailed) {
      pageStatus = PageStatus.error;
    }

    update();
  }
}
