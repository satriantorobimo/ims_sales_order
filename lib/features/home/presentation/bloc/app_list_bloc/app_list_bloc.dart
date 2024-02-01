import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/home/domain/repo/home_repo.dart';
import 'bloc.dart';

class AppListBloc extends Bloc<AppListEvent, AppListState> {
  AppListState get initialState => AppListInitial();
  HomeRepo homeRepo = HomeRepo();
  AppListBloc({required this.homeRepo}) : super(AppListInitial()) {
    on<AppListEvent>((event, emit) async {
      if (event is AppListAttempt) {
        try {
          emit(AppListLoading());
          final appListResponseModel =
              await homeRepo.attemptGetAppList(event.uid);
          if (appListResponseModel!.result == 1) {
            emit(AppListLoaded(appListResponseModel: appListResponseModel));
          } else if (appListResponseModel.result == 0) {
            emit(AppListError(appListResponseModel.message));
          } else {
            emit(const AppListException('error'));
          }
        } catch (e) {
          emit(AppListException(e.toString()));
        }
      }
    });
  }
}
