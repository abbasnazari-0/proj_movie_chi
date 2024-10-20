import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_chi/core/params/profile_updator.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_profile/data/models/profile_model.dart';
import 'package:movie_chi/features/feature_profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl(super.apiProvider);

  @override
  Future<DataState<ProfileModel>> getProfile({String? userAuth}) async {
    try {
      var response = await apiProvider.getProfile(userAuth: userAuth);
      debugPrint(response.data);

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
      debugPrint(response.toString());
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
