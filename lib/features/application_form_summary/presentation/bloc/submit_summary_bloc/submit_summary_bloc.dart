import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_summary/domain/repo/summary_repo.dart';
import 'bloc.dart';

class SubmitSummaryBloc extends Bloc<SubmitSummaryEvent, SubmitSummaryState> {
  SubmitSummaryState get initialState => SubmitSummaryInitial();
  SummaryRepo summaryRepo = SummaryRepo();
  SubmitSummaryBloc({required this.summaryRepo})
      : super(SubmitSummaryInitial()) {
    on<SubmitSummaryEvent>((event, emit) async {
      if (event is SubmitSummaryAttempt) {
        try {
          emit(SubmitSummaryLoading());
          final addClientResponseModel = await summaryRepo
              .attemptSubmitSummary(event.detailSummaryRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(SubmitSummaryLoaded(
                addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(SubmitSummaryError(addClientResponseModel.message));
          } else {
            emit(const SubmitSummaryException('error'));
          }
        } catch (e) {
          emit(SubmitSummaryException(e.toString()));
        }
      }
    });
  }
}
