import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/page_status.dart';
import '../../../feature_home/data/model/home_catagory_model.dart';
import '../../domain/usecases/zhnnaer_usecase.dart';

class ZhannerDetailController extends GetxController {
  ZhannerUseCase zhannerUseCase;
  String title;
  ZhannerDetailController(
    this.zhannerUseCase,
    this.title,
  );

  List<HomeItemData> zhannerDataList = [];
  PageStatus pageStatus = PageStatus.loading;
  int amount = 0;

  @override
  onInit() {
    super.onInit();
    getZhannerDataList(title);
  }

  getZhannerDataList(String title) async {
    amount = 40;
    // if (amount <= 40) {
    //   pageStatus = PageStatus.loading;
    //   update();
    // }

    DataState dataState =
        await zhannerUseCase.getZhannerData(zhannerDataList, title, amount);

    if (dataState is DataSuccess) {
      List<HomeItemData> list = dataState.data;
      if (zhannerDataList.isEmpty) {
        zhannerDataList = list;
      } else {
        zhannerDataList.addAll(list);
      }

      // zhannerDataList = list;
      pageStatus = PageStatus.success;
    } else if (dataState is DataFailed) {
      debugPrint(dataState.error);
      pageStatus = PageStatus.error;
    }
    update();
  }
}
