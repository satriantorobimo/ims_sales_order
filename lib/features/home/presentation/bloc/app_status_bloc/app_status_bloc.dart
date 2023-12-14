import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/home/domain/repo/home_repo.dart';
import 'bloc.dart';

class AppStatusBloc extends Bloc<AppStatusEvent, AppStatusState> {
  AppStatusState get initialState => AppStatusInitial();
  HomeRepo homeRepo = HomeRepo();
  AppStatusBloc({required this.homeRepo}) : super(AppStatusInitial()) {
    on<AppStatusEvent>((event, emit) async {
      if (event is AppStatusAttempt) {
        try {
          emit(AppStatusLoading());
          final appStatusResponseModel = await homeRepo.attemptGetAppStatus();
          if (appStatusResponseModel!.result == 1) {
            emit(AppStatusLoaded(
                appStatusResponseModel: appStatusResponseModel));
          } else if (appStatusResponseModel.result == 0) {
            emit(AppStatusError(appStatusResponseModel.message));
          } else {
            emit(const AppStatusException('error'));
          }
        } catch (e) {
          emit(AppStatusException(e.toString()));
        }
      }
    });
  }
}
