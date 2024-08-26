import 'package:movie_chi/core/params/search_params.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_search/data/models/search_model.dart';

import '../repositories/search_repository.dart';

class SearchUseCase {
  final SearchRepository repository;

  SearchUseCase(this.repository);

  Future<DataState<SearchModel>> call(
      SearchParamsQuery searchParamsQuery) async {
    return await repository.searchQuery(searchParamsQuery);
  }
}
