import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'bloc.dart';

class ZipCodeBloc extends Bloc<ZipCodeEvent, ZipCodeState> {
  ZipCodeState get initialState => ZipCodeInitial();
  Form1Repo form1repo = Form1Repo();
  ZipCodeBloc({required this.form1repo}) : super(ZipCodeInitial()) {
    on<ZipCodeEvent>((event, emit) async {
      if (event is ZipCodeAttempt) {
        try {
          emit(ZipCodeLoading());
          final zipCodeResponseModel =
              await form1repo.attemptLookupZipCode(event.code);
          if (zipCodeResponseModel.result == 1) {
            emit(ZipCodeLoaded(zipCodeResponseModel: zipCodeResponseModel));
          } else if (zipCodeResponseModel.result == 0) {
            emit(ZipCodeError(zipCodeResponseModel.message));
          } else {
            emit(const ZipCodeException('error'));
          }
        } catch (e) {
          emit(ZipCodeException(e.toString()));
        }
      }
    });
  }
}
