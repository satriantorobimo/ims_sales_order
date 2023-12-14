import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_4/domain/repo/form_4_repo.dart';
import 'bloc.dart';

class ModelBloc extends Bloc<ModelEvent, ModelState> {
  ModelState get initialState => ModelInitial();
  Form4Repo form4repo = Form4Repo();
  ModelBloc({required this.form4repo}) : super(ModelInitial()) {
    on<ModelEvent>((event, emit) async {
      if (event is ModelAttempt) {
        try {
          emit(ModelLoading());
          final lookUpMerkModel =
              await form4repo.attemptLookupModel(event.code);
          if (lookUpMerkModel.result == 1) {
            emit(ModelLoaded(lookUpMerkModel: lookUpMerkModel));
          } else if (lookUpMerkModel.result == 0) {
            emit(ModelError(lookUpMerkModel.message));
          } else {
            emit(const ModelException('error'));
          }
        } catch (e) {
          emit(ModelException(e.toString()));
        }
      }
    });
  }
}
