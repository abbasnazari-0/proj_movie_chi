import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_support/data/data_source/remote.dart';
import 'package:movie_chi/features/feature_support/data/model/message_model.dart';

abstract class SupportRepository {
  SupportApiProvider apiProvider;
  SupportRepository({required this.apiProvider});
  Future<DataState<MessageClassModel>> getSupportMessages(int page);
  Future<DataState<MessageClassModel>> sendSupportText(String message);
}
