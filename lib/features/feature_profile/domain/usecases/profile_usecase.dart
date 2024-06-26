import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_profile/data/models/profile_model.dart';
import 'package:movie_chi/features/feature_profile/domain/repositories/profile_repository.dart';

class ProfileUsecase {
  final ProfileRepository repository;

  ProfileUsecase(this.repository);

  Future<DataState<ProfileModel>> getProfile() async {
    return await repository.getProfile();
  }

  Future<DataState<ProfileModel>> updateProfile(params) async {
    return await repository.updateProfile(params);
  }
}
