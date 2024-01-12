import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_7/domain/repo/form_7_repo.dart';
import 'bloc.dart';

class DocDeleteBloc extends Bloc<DocDeleteEvent, DocDeleteState> {
  DocDeleteState get initialState => DocDeleteInitial();
  Form7Repo form7repo = Form7Repo();
  DocDeleteBloc({required this.form7repo}) : super(DocDeleteInitial()) {
    on<DocDeleteEvent>((event, emit) async {
      if (event is DocDeleteAttempt) {
        try {
          emit(DocDeleteLoading());
          final addClientResponseModel = await form7repo
              .attemptDocDelete(event.documentDeleteRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(DocDeleteLoaded(
                addClientResponseModel: addClientResponseModel));
          } else {
            emit(const DocDeleteException('error'));
          }
        } catch (e) {
          emit(DocDeleteException(e.toString()));
        }
      }
    });
  }
}
