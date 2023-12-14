import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_3/domain/repo/form_3_repo.dart';
import 'bloc.dart';

class DealerBloc extends Bloc<DealerEvent, DealerState> {
  DealerState get initialState => DealerInitial();
  Form3Repo form3repo = Form3Repo();
  DealerBloc({required this.form3repo}) : super(DealerInitial()) {
    on<DealerEvent>((event, emit) async {
      if (event is DealerAttempt) {
        try {
          emit(DealerLoading());
          final lookUpDealerModel =
              await form3repo.attemptLookupDealer(event.code);
          if (lookUpDealerModel.result == 1) {
            emit(DealerLoaded(lookUpDealerModel: lookUpDealerModel));
          } else if (lookUpDealerModel.result == 0) {
            emit(DealerError(lookUpDealerModel.message));
          } else {
            emit(const DealerException('error'));
          }
        } catch (e) {
          emit(DealerException(e.toString()));
        }
      }
    });
  }
}
