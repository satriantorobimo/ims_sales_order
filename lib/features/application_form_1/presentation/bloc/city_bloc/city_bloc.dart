import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'bloc.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  CityState get initialState => CityInitial();
  Form1Repo form1repo = Form1Repo();
  CityBloc({required this.form1repo}) : super(CityInitial()) {
    on<CityEvent>((event, emit) async {
      if (event is CityAttempt) {
        try {
          emit(CityLoading());
          final lookUpMsoResponseModel =
              await form1repo.attemptLookupCity(event.code);
          if (lookUpMsoResponseModel.result == 1) {
            emit(CityLoaded(lookUpMsoResponseModel: lookUpMsoResponseModel));
          } else if (lookUpMsoResponseModel.result == 0) {
            emit(CityError(lookUpMsoResponseModel.message));
          } else {
            emit(const CityException('error'));
          }
        } catch (e) {
          emit(CityException(e.toString()));
        }
      }
    });
  }
}
