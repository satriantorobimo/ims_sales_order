import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_7/domain/repo/form_7_repo.dart';
import 'bloc.dart';

class DocUpdateBloc extends Bloc<DocUpdateEvent, DocUpdateState> {
  DocUpdateState get initialState => DocUpdateInitial();
  Form7Repo form7repo = Form7Repo();
  DocUpdateBloc({required this.form7repo}) : super(DocUpdateInitial()) {
    on<DocUpdateEvent>((event, emit) async {
      if (event is DocUpdateAttempt) {
        try {
          emit(DocUpdateLoading());
          final addClientResponseModel =
              await form7repo.attemptDocUpdate(event.documentUDateRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(DocUpdateLoaded(
                addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(DocUpdateError(addClientResponseModel.message));
          } else {
            emit(const DocUpdateException('error'));
          }
        } catch (e) {
          emit(DocUpdateException(e.toString()));
        }
      }
    });
  }
}
