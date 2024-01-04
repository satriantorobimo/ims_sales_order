import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_2/domain/repo/form_2_repo.dart';
import 'bloc.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientState get initialState => ClientInitial();
  Form2Repo form2repo = Form2Repo();
  ClientBloc({required this.form2repo}) : super(ClientInitial()) {
    on<ClientEvent>((event, emit) async {
      if (event is ClientAddAttempt) {
        try {
          emit(ClientLoading());
          final addClientResponseModel =
              await form2repo.attemptAddClient(event.addClientRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(ClientAddLoaded(
                addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(ClientError(addClientResponseModel.message));
          } else {
            emit(const ClientException('error'));
          }
        } catch (e) {
          emit(ClientException(e.toString()));
        }
      }

      if (event is ClientUpdateAttempt) {
        try {
          emit(ClientLoading());
          final addClientResponseModel =
              await form2repo.attemptUpdateClient(event.addClientRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(ClientUpdateLoaded(
                addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(ClientError(addClientResponseModel.message));
          } else {
            emit(const ClientException('error'));
          }
        } catch (e) {
          emit(ClientException(e.toString()));
        }
      }

      if (event is ClientUseAttempt) {
        try {
          emit(ClientLoading());
          final addClientResponseModel =
              await form2repo.attemptUseClient(event.addClientRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(ClientUseLoaded(
                addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(ClientError(addClientResponseModel.message));
          } else {
            emit(const ClientException('error'));
          }
        } catch (e) {
          emit(ClientException(e.toString()));
        }
      }
    });
  }
}
