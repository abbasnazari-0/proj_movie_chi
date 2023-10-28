import 'package:movie_chi/core/resources/data_state.dart';

import '../../../../core/params/play_list_params.dart';
import '../../data/data_sources/remote/play_list_data_getter.dart';
import '../../data/model/play_list_model.dart';
import '../../data/model/session_playlist.dart';

abstract class PlayListRepo {
  final PlayListDataGetter playListDataGetter;

  PlayListRepo(this.playListDataGetter);
  Future<DataState<PlayListModel>> getPlayList(PlayListParams playListParams);
  Future<DataState<SessionModel>> getSessionPlaylist(
      PlayListParams playListParams);
}
