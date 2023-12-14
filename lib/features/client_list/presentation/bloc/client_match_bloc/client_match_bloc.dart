import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/client_list/domain/repo/client_matching_repo.dart';
import 'bloc.dart';

class ClientMatchBloc extends Bloc<ClientMatchEvent, ClientMatchState> {
  ClientMatchState get initialState => ClientMatchInitial();
  ClientMatchingRepo clientMatchingRepo = ClientMatchingRepo();
  ClientMatchBloc({required this.clientMatchingRepo})
      : super(ClientMatchInitial()) {
    on<ClientMatchEvent>((event, emit) async {
      if (event is ClientMatchCorpAttempt) {
        try {
          emit(ClientMatchLoading());
          final clientMathcingCorpResponseModel = await clientMatchingRepo
              .attemptClientMatchingCorp(event.clientMatchingModel);
          if (clientMathcingCorpResponseModel.result == 1) {
            emit(ClientMatchCorpLoaded(
                clientMathcingCorpResponseModel:
                    clientMathcingCorpResponseModel));
          } else if (clientMathcingCorpResponseModel.result == 0) {
            emit(ClientMatchError(clientMathcingCorpResponseModel.message));
          } else {
            emit(const ClientMatchException('error'));
          }
        } catch (e) {
          emit(ClientMatchException(e.toString()));
        }
      }

      if (event is ClientMatchPersonalAttempt) {
        try {
          emit(ClientMatchLoading());
          final clientMathcingPersonalResponseModel = await clientMatchingRepo
              .attemptClientMatchingPersonal(event.clientMatchingModel);
          if (clientMathcingPersonalResponseModel.result == 1) {
            emit(ClientMatchPersonalLoaded(
                clientMathcingPersonalResponseModel:
                    clientMathcingPersonalResponseModel));
          } else if (clientMathcingPersonalResponseModel.result == 0) {
            emit(ClientMatchError(clientMathcingPersonalResponseModel.message));
          } else {
            emit(const ClientMatchException('error'));
          }
        } catch (e) {
          emit(ClientMatchException(e.toString()));
        }
      }
    });
  }
}
