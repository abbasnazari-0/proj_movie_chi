import 'package:bloc/bloc.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_catagory/data/data_source/remote/catagory_params.dart';
import 'package:movie_chi/features/feature_catagory/domain/useacases/catagory_usecase.dart';
import 'package:movie_chi/features/feature_catagory/presentation/bloc/catagory_status.dart';

part 'catagory_event.dart';
part 'catagory_state.dart';

class CatagoryBloc extends Bloc<CatagoryEvent, CatagoryState> {
  final CatagoryUseCase catagoryUseCase;
  CatagoryBloc(this.catagoryUseCase)
      : super(CatagoryState(catagoryStatus: CsLoading())) {
    on<LoadCatagoryEvent>((event, emit) async {
      emit(state.copyWith(catagoryStatus: CsLoading()));

      DataState dataState = await catagoryUseCase(event.catagoryParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(catagoryStatus: CsCompleted(dataState.data)));
      } else if (dataState is DataFailed) {
        emit(state.copyWith(catagoryStatus: CsFailed(dataState.error!)));
      }
    });
  }
}
