import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_new_notification/data/model/news_model.dart';
import 'package:movie_chi/features/feature_new_notification/domain/repository/news_repository.dart';

class NewsRepostiryImpl extends NewsRepository {
  NewsRepostiryImpl({required super.apiProvider});

  @override
  Future<DataState<NewsNotificationModel>> getNotificationMessages() async {
    try {
      Response res = await apiProvider.getMessages();
      if (res.statusCode == 200) {
        NewsNotificationModel messageClassModel =
            NewsNotificationModel.fromJson(jsonDecode(res.data));

        return DataSuccess(messageClassModel);
      } else {
        return DataFailed(res.data);
      }
    } catch (e) {
      return DataFailed("error on internet ${e.toString()}");
    }
  }
}
