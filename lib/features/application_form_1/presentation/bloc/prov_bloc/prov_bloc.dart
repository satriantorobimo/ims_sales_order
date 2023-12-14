import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'bloc.dart';

class ProvBloc extends Bloc<ProvEvent, ProvState> {
  ProvState get initialState => ProvInitial();
  Form1Repo form1repo = Form1Repo();
  ProvBloc({required this.form1repo}) : super(ProvInitial()) {
    on<ProvEvent>((event, emit) async {
      if (event is ProvAttempt) {
        try {
          emit(ProvLoading());
          final lookUpMsoResponseModel =
              await form1repo.attemptLookupProv(event.code);
          if (lookUpMsoResponseModel.result == 1) {
            emit(ProvLoaded(lookUpMsoResponseModel: lookUpMsoResponseModel));
          } else if (lookUpMsoResponseModel.result == 0) {
            emit(ProvError(lookUpMsoResponseModel.message));
          } else {
            emit(const ProvException('error'));
          }
        } catch (e) {
          emit(ProvException(e.toString()));
        }
      }
    });
  }
}
