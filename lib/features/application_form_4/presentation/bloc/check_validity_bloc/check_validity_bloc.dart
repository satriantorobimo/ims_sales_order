import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_4/domain/repo/form_4_repo.dart';
import 'bloc.dart';

class CheckValidityBloc extends Bloc<CheckValidityEvent, CheckValidityState> {
  CheckValidityState get initialState => CheckValidityInitial();
  Form4Repo form4repo = Form4Repo();
  CheckValidityBloc({required this.form4repo}) : super(CheckValidityInitial()) {
    on<CheckValidityEvent>((event, emit) async {
      if (event is CheckValidityAttempt) {
        try {
          emit(CheckValidityLoading());
          final checkScoringResponseModel =
              await form4repo.attemptCheckValidity(event.code);
          if (checkScoringResponseModel.result == 1) {
            emit(CheckValidityLoaded(
                checkScoringResponseModel: checkScoringResponseModel));
          } else if (checkScoringResponseModel.result == 0) {
            emit(CheckValidityError(checkScoringResponseModel.message));
          } else {
            emit(const CheckValidityException('error'));
          }
        } catch (e) {
          emit(CheckValidityException(e.toString()));
        }
      }
    });
  }
}
