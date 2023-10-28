import 'package:movie_chi/features/feature_plans/domain/repositories/plan_repositry.dart';

class PlanUseCase {
  final PlanRepository planRepository;

  PlanUseCase(this.planRepository);

  Future getPlans() async {
    return await planRepository.getPlans();
  }
}
