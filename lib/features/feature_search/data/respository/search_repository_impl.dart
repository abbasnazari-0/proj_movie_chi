import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_chi/core/models/search_video_model.dart';
import 'package:movie_chi/core/params/search_params.dart';

import 'package:movie_chi/core/resources/data_state.dart';

import '../../domain/repositories/search_repository.dart';
import '../data_source/remote/searchGetData.dart';

class SearchReposityImpl extends SearchRepository {
  final SearchDataGetter searchDataGetter;

  SearchReposityImpl({required this.searchDataGetter});

  int searchRetries = 0;

  @override
  Future<DataState<List<SearchVideo>>> searchQuery(
      SearchParamsQuery searchParamsQuery) async {
    Response res = await searchDataGetter.getData(searchParamsQuery);
    // print(res.data);
    if (res.statusCode == 200) {
      List<SearchVideo> searchVideoList = [];

      if (res.data.toString().contains('0 results')) {
        return DataFailed("not found");
      }

      List data = jsonDecode(res.data);
      for (var element in data) {
        searchVideoList.add(SearchVideo.fromJson(element));
      }
      return DataSuccess(searchVideoList);
    } else {
      if (searchRetries < 2) {
        searchRetries++;
        return searchQuery(searchParamsQuery);
      }
      return DataFailed(res.statusMessage.toString());
    }
  }
}
