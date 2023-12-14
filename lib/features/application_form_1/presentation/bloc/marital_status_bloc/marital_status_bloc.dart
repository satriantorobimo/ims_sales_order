import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'bloc.dart';

class MaritalStatusBloc extends Bloc<MaritalStatusEvent, MaritalStatusState> {
  MaritalStatusState get initialState => MaritalStatusInitial();
  Form1Repo form1repo = Form1Repo();
  MaritalStatusBloc({required this.form1repo}) : super(MaritalStatusInitial()) {
    on<MaritalStatusEvent>((event, emit) async {
      if (event is MaritalStatusAttempt) {
        try {
          emit(MaritalStatusLoading());
          final lookUpMsoResponseModel =
              await form1repo.attemptLookupMso(event.code);
          if (lookUpMsoResponseModel.result == 1) {
            emit(MaritalStatusLoaded(
                lookUpMsoResponseModel: lookUpMsoResponseModel));
          } else if (lookUpMsoResponseModel.result == 0) {
            emit(MaritalStatusError(lookUpMsoResponseModel.message));
          } else {
            emit(const MaritalStatusException('error'));
          }
        } catch (e) {
          emit(MaritalStatusException(e.toString()));
        }
      }
    });
  }
}
