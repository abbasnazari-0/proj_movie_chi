import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_plans/data/data_source/data_source.dart';
import 'package:movie_chi/features/feature_plans/data/models/plan_model.dart';

abstract class PlanRepository {
  final PlanApiProvider planApiProvider;

  PlanRepository(this.planApiProvider);
  Future<DataState<PlanModel>> getPlans();
}
