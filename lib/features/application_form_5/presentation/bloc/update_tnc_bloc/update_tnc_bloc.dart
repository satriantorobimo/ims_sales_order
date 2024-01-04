import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_5/domain/repo/form_5_repo.dart';
import 'bloc.dart';

class UpdateTncBloc extends Bloc<UpdateTncEvent, UpdateTncState> {
  UpdateTncState get initialState => UpdateTncInitial();
  Form5Repo form5repo = Form5Repo();
  UpdateTncBloc({required this.form5repo}) : super(UpdateTncInitial()) {
    on<UpdateTncEvent>((event, emit) async {
      if (event is UpdateTncAttempt) {
        try {
          emit(UpdateTncLoading());
          final addClientResponseModel =
              await form5repo.attemptUpdateTncData(event.updateTncRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(UpdateTncLoaded(
                addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(UpdateTncError(addClientResponseModel.message));
          } else {
            emit(UpdateTncException(addClientResponseModel.message!));
          }
        } catch (e) {
          emit(UpdateTncException(e.toString()));
        }
      }
    });
  }
}
