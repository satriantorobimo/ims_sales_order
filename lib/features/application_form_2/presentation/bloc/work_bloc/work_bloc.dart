import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_2/domain/repo/form_2_repo.dart';
import 'bloc.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {
  WorkState get initialState => WorkInitial();
  Form2Repo form2repo = Form2Repo();
  WorkBloc({required this.form2repo}) : super(WorkInitial()) {
    on<WorkEvent>((event, emit) async {
      if (event is WorkAttempt) {
        try {
          emit(WorkLoading());
          final lookUpMsoResponseModel =
              await form2repo.attemptLookupMso(event.code);
          if (lookUpMsoResponseModel.result == 1) {
            emit(WorkLoaded(lookUpMsoResponseModel: lookUpMsoResponseModel));
          } else if (lookUpMsoResponseModel.result == 0) {
            emit(WorkError(lookUpMsoResponseModel.message));
          } else {
            emit(const WorkException('error'));
          }
        } catch (e) {
          emit(WorkException(e.toString()));
        }
      }
    });
  }
}
