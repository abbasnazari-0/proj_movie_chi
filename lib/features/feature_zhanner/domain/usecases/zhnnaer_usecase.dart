import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_zhanner/data/model/zhanner_data_model.dart';
import 'package:movie_chi/features/feature_zhanner/domain/repositories/zhanner_repository.dart';

import '../../../feature_home/data/model/home_catagory_model.dart';

class ZhannerUseCase {
  ZhannerRepository zhannerRepository;
  ZhannerUseCase({
    required this.zhannerRepository,
  });

  Future<DataState<List<Zhanner>>> getZhanner() async {
    return await zhannerRepository.getZhanner();
  }

  Future<DataState<List<HomeItemData>>> getZhannerData(
      List<HomeItemData> itemData, String title, int amount) async {
    return await zhannerRepository.getZhannerData(itemData, title, amount);
  }
}
