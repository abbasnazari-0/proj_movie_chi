import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_play_list/data/model/play_list_model.dart';
import 'package:movie_chi/features/feature_play_list/domain/repositories/play_list_repository.dart';

import '../../../../core/params/play_list_params.dart';
import '../../data/model/session_playlist.dart';

class PlayListUseCase {
  final PlayListRepo _repository;

  PlayListUseCase(this._repository);

  Future<DataState<PlayListModel>> getPlayList(
      PlayListParams playListParams) async {
    return await _repository.getPlayList(playListParams);
  }

  Future<DataState<SessionModel>> getSessionPlaylist(
      PlayListParams playListParams) async {
    return await _repository.getSessionPlaylist(playListParams);
  }
}
