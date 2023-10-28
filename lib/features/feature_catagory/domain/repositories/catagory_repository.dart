import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_catagory/data/data_source/remote/catagory_params.dart';
import 'package:movie_chi/features/feature_catagory/domain/entities/catagory_entity.dart';

abstract class CatagoryRepository {
  const CatagoryRepository();

  Future<DataState<CatagoryEntity>> call(CatagoryParams catagoryParams);
}
