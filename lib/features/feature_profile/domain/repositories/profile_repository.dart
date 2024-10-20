import 'package:movie_chi/core/params/profile_updator.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_profile/data/data_sources/api_provider.dart';
import 'package:movie_chi/features/feature_profile/data/models/profile_model.dart';

abstract class ProfileRepository {
  final ProfileApiProvider apiProvider;

  ProfileRepository(this.apiProvider);

  Future<DataState<ProfileModel>> getProfile({String? userAuth});

  Future<DataState<ProfileModel>> updateProfile(ProfileUpdator params);
}
