import 'package:movie_chi/core/params/search_params.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/models/search_video_model.dart';

import '../repositories/search_repository.dart';

class SearchUseCase {
  final SearchRepository repository;

  SearchUseCase(this.repository);

  Future<DataState<List<SearchVideo>>> call(
      SearchParamsQuery searchParamsQuery) async {
    return await repository.searchQuery(searchParamsQuery);
  }
}
