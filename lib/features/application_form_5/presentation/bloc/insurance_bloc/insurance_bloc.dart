import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_5/domain/repo/form_5_repo.dart';
import 'bloc.dart';

class InsuranceBloc extends Bloc<InsuranceEvent, InsuranceState> {
  InsuranceState get initialState => InsuranceInitial();
  Form5Repo form5repo = Form5Repo();
  InsuranceBloc({required this.form5repo}) : super(InsuranceInitial()) {
    on<InsuranceEvent>((event, emit) async {
      if (event is InsuranceAttempt) {
        try {
          emit(InsuranceLoading());
          final lookUpInsurancePackageModel =
              await form5repo.attemptLookupInsurance(event.code);
          if (lookUpInsurancePackageModel.result == 1) {
            emit(InsuranceLoaded(
                lookUpInsurancePackageModel: lookUpInsurancePackageModel));
          } else if (lookUpInsurancePackageModel.result == 0) {
            emit(InsuranceError(lookUpInsurancePackageModel.message));
          } else {
            emit(const InsuranceException('error'));
          }
        } catch (e) {
          emit(InsuranceException(e.toString()));
        }
      }
    });
  }
}
