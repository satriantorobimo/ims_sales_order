import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'bloc.dart';

class GetClientBloc extends Bloc<GetClientEvent, GetClientState> {
  GetClientState get initialState => GetClientInitial();
  Form1Repo form1repo = Form1Repo();
  GetClientBloc({required this.form1repo}) : super(GetClientInitial()) {
    on<GetClientEvent>((event, emit) async {
      if (event is GetClientAttempt) {
        try {
          emit(GetClientLoading());
          final clientDetailResponseModel =
              await form1repo.attemptGetClient(event.code);
          if (clientDetailResponseModel.result == 1) {
            emit(GetClientLoaded(
                clientDetailResponseModel: clientDetailResponseModel));
          } else if (clientDetailResponseModel.result == 0) {
            emit(GetClientError(clientDetailResponseModel.message));
          } else {
            emit(const GetClientException('error'));
          }
        } catch (e) {
          emit(GetClientException(e.toString()));
        }
      }
    });
  }
}
