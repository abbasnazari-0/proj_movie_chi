import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_support/data/model/message_model.dart';
import 'package:movie_chi/features/feature_support/domain/repository/support_repository.dart';

class SupportUseCase {
  SupportRepository repository;
  SupportUseCase({required this.repository});

  Future<DataState<MessageClassModel>> getSupportMessages(int page) async {
    return await repository.getSupportMessages(page);
  }

  Future<DataState<MessageClassModel>> sendSupportText(String message) async {
    return await repository.sendSupportText(message);
  }
}
