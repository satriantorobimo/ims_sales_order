import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'bloc.dart';

class CheckScoringBloc extends Bloc<CheckScoringEvent, CheckScoringState> {
  CheckScoringState get initialState => CheckScoringInitial();
  Form1Repo form1repo = Form1Repo();
  CheckScoringBloc({required this.form1repo}) : super(CheckScoringInitial()) {
    on<CheckScoringEvent>((event, emit) async {
      if (event is CheckScoringAttempt) {
        try {
          emit(CheckScoringLoading());
          final checkScoringResponseModel =
              await form1repo.attemptCheclScoring(event.code);
          if (checkScoringResponseModel.result == 1) {
            emit(CheckScoringLoaded(
                checkScoringResponseModel: checkScoringResponseModel));
          } else if (checkScoringResponseModel.result == 0) {
            emit(CheckScoringError(checkScoringResponseModel.message));
          } else {
            emit(const CheckScoringException('error'));
          }
        } catch (e) {
          emit(CheckScoringException(e.toString()));
        }
      }
    });
  }
}
