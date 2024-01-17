import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_5/domain/repo/form_5_repo.dart';
import 'bloc.dart';

class UpdateFeeBloc extends Bloc<UpdateFeeEvent, UpdateFeeState> {
  UpdateFeeState get initialState => UpdateFeeInitial();
  Form5Repo form5repo = Form5Repo();
  UpdateFeeBloc({required this.form5repo}) : super(UpdateFeeInitial()) {
    on<UpdateFeeEvent>((event, emit) async {
      if (event is UpdateFeeAttempt) {
        try {
          emit(UpdateFeeLoading());
          final addClientResponseModel =
              await form5repo.attemptUpdateFeeData(event.updateFeeRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(UpdateFeeLoaded(
                addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(UpdateFeeError(addClientResponseModel.message));
          } else {
            emit(UpdateFeeException(addClientResponseModel.message!));
          }
        } catch (e) {
          emit(UpdateFeeException(e.toString()));
        }
      }
    });
  }
}
