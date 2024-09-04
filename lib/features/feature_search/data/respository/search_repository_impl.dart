import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_chi/core/params/search_params.dart';

import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_search/data/models/search_model.dart';

import '../../domain/repositories/search_repository.dart';
import '../data_source/remote/search_api_provider.dart';

class SearchReposityImpl extends SearchRepository {
  final SearchDataGetter searchDataGetter;

  SearchReposityImpl({required this.searchDataGetter});

  int searchRetries = 0;

  @override
  Future<DataState<SearchModel>> searchQuery(
      SearchParamsQuery searchParamsQuery) async {
    Response res = await searchDataGetter.getData(searchParamsQuery);
    // print(res.data);
    if (res.statusCode == 200) {
      if (res.data.toString().contains('0 results')) {
        return DataFailed("not found");
      }

      return DataSuccess(SearchModel.fromJson(jsonDecode(res.data)));
    } else {
      if (searchRetries < 2) {
        searchRetries++;
        return searchQuery(searchParamsQuery);
      }
      return DataFailed(res.statusMessage.toString());
    }
  }
}
