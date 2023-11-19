import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_new_notification/data/model/news_model.dart';
import 'package:movie_chi/features/feature_new_notification/domain/repository/news_repository.dart';

class NewsUseCase {
  NewsRepository repository;
  NewsUseCase({required this.repository});

  Future<DataState<NewsNotificationModel>> getSupportMessages() async {
    return await repository.getNotificationMessages();
  }
}
