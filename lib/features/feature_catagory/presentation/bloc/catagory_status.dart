import 'package:movie_chi/features/feature_catagory/domain/entities/catagory_entity.dart';

abstract class CatagoryStatus {}

class CsLoading extends CatagoryStatus {}

class CsCompleted extends CatagoryStatus {
  final CatagoryEntity catagoryEntity;
  CsCompleted(this.catagoryEntity);
}

class CsFailed extends CatagoryStatus {
  final String message;
  CsFailed(this.message);
}
