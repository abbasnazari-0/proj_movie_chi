import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_zhanner/data/model/zhanner_data_model.dart';

import '../../../feature_home/data/model/home_catagory_model.dart';
import '../../data/data_source/remote/zhanner_data_source.dart';

abstract class ZhannerRepository {
  ZhannerDataSource zhannerDataSource;
  ZhannerRepository({
    required this.zhannerDataSource,
  });
  Future<DataState<List<Zhanner>>> getZhanner();

  Future<DataState<List<HomeItemData>>> getZhannerData(
      List<HomeItemData> itemData, String title, int amount);
}
