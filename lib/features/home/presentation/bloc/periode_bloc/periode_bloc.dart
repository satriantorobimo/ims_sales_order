import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/home/domain/repo/home_repo.dart';
import 'bloc.dart';

class PeriodeBloc extends Bloc<PeriodeEvent, PeriodeState> {
  PeriodeState get initialState => PeriodeInitial();
  HomeRepo homeRepo = HomeRepo();
  PeriodeBloc({required this.homeRepo}) : super(PeriodeInitial()) {
    on<PeriodeEvent>((event, emit) async {
      if (event is PeriodeAttempt) {
        try {
          emit(PeriodeLoading());
          final dataPeriodeResponseModel = await homeRepo.attemptPeriodeList();
          if (dataPeriodeResponseModel!.result == 1) {
            emit(PeriodeLoaded(
                dataPeriodeResponseModel: dataPeriodeResponseModel));
          } else if (dataPeriodeResponseModel.result == 0) {
            emit(PeriodeError(dataPeriodeResponseModel.message));
          } else {
            emit(const PeriodeException('error'));
          }
        } catch (e) {
          emit(PeriodeException(e.toString()));
        }
      }
    });
  }
}
