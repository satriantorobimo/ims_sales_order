import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_3/domain/repo/form_3_repo.dart';
import 'bloc.dart';

class UpdateLoanDataBloc
    extends Bloc<UpdateLoanDataEvent, UpdateLoanDataState> {
  UpdateLoanDataState get initialState => UpdateLoanDataInitial();
  Form3Repo form3repo = Form3Repo();
  UpdateLoanDataBloc({required this.form3repo})
      : super(UpdateLoanDataInitial()) {
    on<UpdateLoanDataEvent>((event, emit) async {
      if (event is UpdateLoanDataAttempt) {
        try {
          emit(UpdateLoanDataLoading());
          final addClientResponseModel = await form3repo
              .attemptUpdateLoanData(event.updateLoanDataRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(UpdateLoanDataLoaded(
                addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(UpdateLoanDataError(addClientResponseModel.message));
          } else {
            emit(const UpdateLoanDataException('error'));
          }
        } catch (e) {
          emit(UpdateLoanDataException(e.toString()));
        }
      }
    });
  }
}
