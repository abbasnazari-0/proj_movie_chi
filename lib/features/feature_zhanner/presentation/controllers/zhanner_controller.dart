import 'package:get/state_manager.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_zhanner/data/model/zhanner_data_model.dart';

import '../../domain/usecases/zhnnaer_usecase.dart';

class ZhannerController extends GetxController {
  ZhannerUseCase zhannerUseCase;
  ZhannerController(this.zhannerUseCase);

  List<Zhanner> zhannerList = [];
  PageStatus pageStatus = PageStatus.loading;

  @override
  void onInit() {
    super.onInit();
    getZhannerData();
  }

  getZhannerData() async {
    pageStatus = PageStatus.loading;
    update();
    DataState dataState = await zhannerUseCase.getZhanner();

    if (dataState is DataSuccess) {
      List<Zhanner> list = dataState.data;

      zhannerList = list;
      pageStatus = PageStatus.success;
    } else if (dataState is DataFailed) {
      pageStatus = PageStatus.error;
    }
    update();
  }
}
