import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_chi/features/feature_catagory/data/data_source/remote/catagory_params.dart';
import 'package:movie_chi/features/feature_catagory/data/data_source/remote/dataGettercatagory.dart';
import 'package:movie_chi/features/feature_catagory/data/model/cataogory_model.dart';
import 'package:movie_chi/features/feature_catagory/domain/entities/catagory_entity.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_catagory/domain/repositories/catagory_repository.dart';

class CatagroyRepositoryImpl extends CatagoryRepository {
  final DataGetterCatagory dataGetterCatagory;

  CatagroyRepositoryImpl(this.dataGetterCatagory);

  @override
  Future<DataState<CatagoryEntity>> call(CatagoryParams catagoryParams) async {
    try {
      Response res = await dataGetterCatagory.getData(catagoryParams);

      if (res.statusCode == 200) {
        Iterable l = json.decode(res.data);
        List<CatagoryEntity> data =
            List<CatagoryEntity>.from(l.map((e) => CatagoryModel.fromJson(e)));

        return DataSuccess(data);
      } else {
        return DataFailed('somthing went wrong');
      }
    } catch (e) {
      return DataFailed('please Check connection!');
    }
  }
}
