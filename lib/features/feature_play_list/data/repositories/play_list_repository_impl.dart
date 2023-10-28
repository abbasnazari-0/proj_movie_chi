import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_chi/core/resources/data_state.dart';

import 'package:movie_chi/features/feature_play_list/data/model/play_list_model.dart';

import '../../../../core/params/play_list_params.dart';
import '../../domain/repositories/play_list_repository.dart';
import '../model/session_playlist.dart';

class PlayListRepositoryImpl extends PlayListRepo {
  PlayListRepositoryImpl(super.playListDataGetter);

  @override
  Future<DataState<PlayListModel>> getPlayList(
      PlayListParams playListParams) async {
    try {
      Response res = await playListDataGetter.getPlayList(playListParams);
      if (res.statusCode == 200) {
        PlayListModel playListModel =
            PlayListModel.fromJson(json.decode(res.data));
        if (playListModel.code == "200") {
          return DataSuccess(playListModel);
        } else {
          return DataFailed(playListModel.message);
        }
      } else {
        return DataFailed("error in getting data");
      }
    } catch (e) {
      return DataFailed("Something went wrong");
    }
  }

  @override
  Future<DataState<SessionModel>> getSessionPlaylist(
      PlayListParams playListParams) async {
    try {
      Response res = await playListDataGetter.getPlayList(playListParams);
      if (res.statusCode == 200) {
        SessionModel playListModel =
            SessionModel.fromJson(json.decode(res.data));
        if (playListModel.code == "200") {
          return DataSuccess(playListModel);
        } else {
          return DataFailed(playListModel.message);
        }
      } else {
        return DataFailed("error in getting data");
      }
    } catch (e) {
      return DataFailed("Something went wrong");
    }
  }
}
