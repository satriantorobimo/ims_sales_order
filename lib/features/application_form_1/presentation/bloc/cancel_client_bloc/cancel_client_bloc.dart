import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'bloc.dart';

class CancelClientBloc extends Bloc<CancelClientEvent, CancelClientState> {
  CancelClientState get initialState => CancelClientInitial();
  Form1Repo form1repo = Form1Repo();
  CancelClientBloc({required this.form1repo}) : super(CancelClientInitial()) {
    on<CancelClientEvent>((event, emit) async {
      if (event is CancelClientAttempt) {
        try {
          emit(CancelClientLoading());
          final addClientResponseModel =
              await form1repo.attemptCancel(event.code);
          if (addClientResponseModel.result == 1) {
            emit(CancelClientLoaded(
                addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(CancelClientError(addClientResponseModel.message));
          } else {
            emit(const CancelClientException('error'));
          }
        } catch (e) {
          emit(CancelClientException(e.toString()));
        }
      }
    });
  }
}
