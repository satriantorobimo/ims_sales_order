import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_2/domain/repo/form_2_repo.dart';
import 'bloc.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  BankState get initialState => BankInitial();
  Form2Repo form2repo = Form2Repo();
  BankBloc({required this.form2repo}) : super(BankInitial()) {
    on<BankEvent>((event, emit) async {
      if (event is BankAttempt) {
        try {
          emit(BankLoading());
          final lookUpMsoResponseModel =
              await form2repo.attemptLookupBank(event.code);
          if (lookUpMsoResponseModel.result == 1) {
            emit(BankLoaded(lookUpMsoResponseModel: lookUpMsoResponseModel));
          } else if (lookUpMsoResponseModel.result == 0) {
            emit(BankError(lookUpMsoResponseModel.message));
          } else {
            emit(const BankException('error'));
          }
        } catch (e) {
          emit(BankException(e.toString()));
        }
      }
    });
  }
}
