import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';
import 'package:movie_chi/features/feature_zhanner/data/model/zhanner_data_model.dart';
import 'package:movie_chi/features/feature_zhanner/domain/repositories/zhanner_repository.dart';

import '../../../feature_home/data/model/grid_model.dart';

class ZhannerRepositoryImpl extends ZhannerRepository {
  ZhannerRepositoryImpl({required super.zhannerDataSource});

  @override
  Future<DataState<List<Zhanner>>> getZhanner() async {
    try {
      Response res = await zhannerDataSource.getZhannerList();

      if (res.statusCode == 200) {
        // return DataSuccess(Zhanner.fromJson(json.decode((res.data))));

        List<Zhanner> list = json
            .decode(res.data)
            .map<Zhanner>((item) => Zhanner.fromJson(item))
            .toList();
        return DataSuccess(list);
      } else {
        return DataFailed("sonthing went wrong ${res.statusCode}}");
      }
    } catch (e) {
      return DataFailed("error in internet connection");
    }
  }

  @override
  Future<DataState<List<HomeItemData>>> getZhannerData(
      List<HomeItemData> itemData, String title, int amount) async {
    try {
      Response res =
          await zhannerDataSource.getZhannerData(itemData, title, amount);

      if (res.statusCode == 200) {
        // return DataSuccess(Zhanner.fromJson(json.decode((res.data))));

        GridModel list = GridModel.fromJson(json.decode(res.data));

        return DataSuccess(list.data);
      } else {
        return DataFailed("sonthing went wrong ${res.statusCode}}");
      }
    } catch (e) {
      return DataFailed("error in internet connection");
    }
  }
}
