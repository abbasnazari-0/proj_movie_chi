import 'dart:convert';

import 'package:movie_chi/core/params/profile_updator.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_profile/data/models/profile_model.dart';
import 'package:movie_chi/features/feature_profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl(super.apiProvider);

  @override
  Future<DataState<ProfileModel>> getProfile() async {
    try {
      var response = await apiProvider.getProfile();

      if (response.statusCode == 200) {
        return DataSuccess(ProfileModel.fromJson(json.decode(response.data)));
      } else {
        return DataFailed(response.statusMessage);
      }
    } catch (e) {
      return DataFailed("error on internet connection");
    }
  }

  @override
  Future<DataState<ProfileModel>> updateProfile(ProfileUpdator params) async {
    try {
      var response = await apiProvider.updateProfile(params);
      print(response);
      if (response.statusCode == 200) {
        return DataSuccess(ProfileModel.fromJson(json.decode(response.data)));
      } else {
        return DataFailed(response.statusMessage);
      }
    } catch (e) {
      return DataFailed("error on internet connection");
    }
  }
}
