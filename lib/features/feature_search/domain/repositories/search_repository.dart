import 'package:movie_chi/core/params/search_params.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_search/data/models/search_model.dart';

abstract class SearchRepository {
  Future<DataState<SearchModel>> searchQuery(
      SearchParamsQuery searchParamsQuery);
}
