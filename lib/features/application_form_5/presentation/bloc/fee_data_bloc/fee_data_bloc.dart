import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_5/domain/repo/form_5_repo.dart';
import 'bloc.dart';

class FeeDataBloc extends Bloc<FeeDataEvent, FeeDataState> {
  FeeDataState get initialState => FeeDataInitial();
  Form5Repo form5repo = Form5Repo();
  FeeDataBloc({required this.form5repo}) : super(FeeDataInitial()) {
    on<FeeDataEvent>((event, emit) async {
      if (event is FeeDataAttempt) {
        try {
          emit(FeeDataLoading());
          final applicationFeeDetailModel =
              await form5repo.attemptGetFeeData(event.code);
          if (applicationFeeDetailModel.result == 1) {
            emit(FeeDataLoaded(
                applicationFeeDetailModel: applicationFeeDetailModel));
          } else if (applicationFeeDetailModel.result == 0) {
            emit(FeeDataError(applicationFeeDetailModel.message));
          } else {
            emit(const FeeDataException('error'));
          }
        } catch (e) {
          emit(FeeDataException(e.toString()));
        }
      }
    });
  }
}
