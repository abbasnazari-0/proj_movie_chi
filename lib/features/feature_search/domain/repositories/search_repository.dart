import 'package:movie_chi/core/resources/data_state.dart';

import '../../../../core/models/search_video_model.dart';

abstract class SearchRepository {
  Future<DataState<List<SearchVideo>>> searchQuery(String query, int count);
}
