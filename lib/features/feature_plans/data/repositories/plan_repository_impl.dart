import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_plans/data/models/plan_model.dart';
import 'package:movie_chi/features/feature_plans/domain/repositories/plan_repositry.dart';
import 'package:dio/dio.dart' show Response;

class PlanRepositoryImpl extends PlanRepository {
  PlanRepositoryImpl(super.planApiProvider);

  @override
  Future<DataState<PlanModel>> getPlans() async {
    try {
      Response res = await planApiProvider.getPlan();
      if (res.statusCode == 200) {
        return DataSuccess(PlanModel.fromJson(res.data));
      } else {
        return DataFailed("error on internet");
      }
    } catch (e) {
      return DataFailed("error on internet");
    }
  }
}
