import 'package:dio/dio.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_support/data/model/message_model.dart';
import 'package:movie_chi/features/feature_support/domain/repository/support_repository.dart';

class SupportRepositoryImpl extends SupportRepository {
  SupportRepositoryImpl({required super.apiProvider});

  @override
  Future<DataState<MessageClassModel>> getSupportMessages(int page) async {
    try {
      Response res = await apiProvider.getMessages(page);
      if (res.statusCode == 200) {
        MessageClassModel messageClassModel =
            MessageClassModel.fromJson(res.data);

        return DataSuccess(messageClassModel);
      } else {
        return DataFailed(res.data);
      }
    } catch (e) {
      return DataFailed("error on internet ${e.toString()}");
    }
  }

  @override
  Future<DataState<MessageClassModel>> sendSupportText(String message) async {
    try {
      Response res = await apiProvider.sendMessage(message);
      if (res.statusCode == 200) {
        MessageClassModel messageClassModel =
            MessageClassModel.fromJson(res.data);

        return DataSuccess(messageClassModel);
      } else {
        return DataFailed(res.data);
      }
    } catch (e) {
      return Future.value(DataFailed("error on internet"));
    }
  }
}
