import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_summary/domain/repo/summary_repo.dart';
import 'bloc.dart';

class DetailSummaryBloc extends Bloc<DetailSummaryEvent, DetailSummaryState> {
  DetailSummaryState get initialState => DetailSummaryInitial();
  SummaryRepo summaryRepo = SummaryRepo();
  DetailSummaryBloc({required this.summaryRepo})
      : super(DetailSummaryInitial()) {
    on<DetailSummaryEvent>((event, emit) async {
      if (event is DetailSummaryAttempt) {
        try {
          emit(DetailSummaryLoading());
          final detailSummaryResponseModel =
              await summaryRepo.attemptDetailSummary(event.code);
          if (detailSummaryResponseModel.result == 1) {
            emit(DetailSummaryLoaded(
                detailSummaryResponseModel: detailSummaryResponseModel));
          } else if (detailSummaryResponseModel.result == 0) {
            emit(DetailSummaryError(detailSummaryResponseModel.message));
          } else {
            emit(const DetailSummaryException('error'));
          }
        } catch (e) {
          emit(DetailSummaryException(e.toString()));
        }
      }
    });
  }
}
