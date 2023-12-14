import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_5/domain/repo/form_5_repo.dart';
import 'bloc.dart';

class TncDataBloc extends Bloc<TncDataEvent, TncDataState> {
  TncDataState get initialState => TncDataInitial();
  Form5Repo form5repo = Form5Repo();
  TncDataBloc({required this.form5repo}) : super(TncDataInitial()) {
    on<TncDataEvent>((event, emit) async {
      if (event is TncDataAttempt) {
        try {
          emit(TncDataLoading());
          final tncDataDetailResponseModel =
              await form5repo.attemptGetTncData(event.code);
          if (tncDataDetailResponseModel.result == 1) {
            emit(TncDataLoaded(
                tncDataDetailResponseModel: tncDataDetailResponseModel));
          } else if (tncDataDetailResponseModel.result == 0) {
            emit(TncDataError(tncDataDetailResponseModel.message));
          } else {
            emit(const TncDataException('error'));
          }
        } catch (e) {
          emit(TncDataException(e.toString()));
        }
      }
    });
  }
}
