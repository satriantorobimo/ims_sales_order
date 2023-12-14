import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_2/domain/repo/form_2_repo.dart';
import 'bloc.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  FamilyState get initialState => FamilyInitial();
  Form2Repo form2repo = Form2Repo();
  FamilyBloc({required this.form2repo}) : super(FamilyInitial()) {
    on<FamilyEvent>((event, emit) async {
      if (event is FamilyAttempt) {
        try {
          emit(FamilyLoading());
          final lookUpMsoResponseModel =
              await form2repo.attemptLookupMso(event.code);
          if (lookUpMsoResponseModel.result == 1) {
            emit(FamilyLoaded(lookUpMsoResponseModel: lookUpMsoResponseModel));
          } else if (lookUpMsoResponseModel.result == 0) {
            emit(FamilyError(lookUpMsoResponseModel.message));
          } else {
            emit(const FamilyException('error'));
          }
        } catch (e) {
          emit(FamilyException(e.toString()));
        }
      }
    });
  }
}
