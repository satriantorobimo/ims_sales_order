import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_3/domain/repo/form_3_repo.dart';
import 'bloc.dart';

class LoanDataDetailBloc
    extends Bloc<LoanDataDetailEvent, LoanDataDetailState> {
  LoanDataDetailState get initialState => LoanDataDetailInitial();
  Form3Repo form3repo = Form3Repo();
  LoanDataDetailBloc({required this.form3repo})
      : super(LoanDataDetailInitial()) {
    on<LoanDataDetailEvent>((event, emit) async {
      if (event is LoanDataDetailAttempt) {
        try {
          emit(LoanDataDetailLoading());
          final loanDataDetailResponseModel =
              await form3repo.attemptGetLoanData(event.code);
          if (loanDataDetailResponseModel.result == 1) {
            emit(LoanDataDetailLoaded(
                loanDataDetailResponseModel: loanDataDetailResponseModel));
          } else if (loanDataDetailResponseModel.result == 0) {
            emit(LoanDataDetailError(loanDataDetailResponseModel.message));
          } else {
            emit(const LoanDataDetailException('error'));
          }
        } catch (e) {
          emit(LoanDataDetailException(e.toString()));
        }
      }
    });
  }
}
