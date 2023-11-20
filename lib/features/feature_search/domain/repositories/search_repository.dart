import 'package:movie_chi/core/params/search_params.dart';
import 'package:movie_chi/core/resources/data_state.dart';

import '../../../../core/models/search_video_model.dart';

abstract class SearchRepository {
  Future<DataState<List<SearchVideo>>> searchQuery(
      SearchParamsQuery searchParamsQuery);
}
