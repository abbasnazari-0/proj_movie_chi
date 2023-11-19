import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_new_notification/data/data_source/remote.dart';
import 'package:movie_chi/features/feature_new_notification/data/model/news_model.dart';

abstract class NewsRepository {
  NewsApiProvider apiProvider;
  NewsRepository({required this.apiProvider});
  Future<DataState<NewsNotificationModel>> getNotificationMessages();
}
