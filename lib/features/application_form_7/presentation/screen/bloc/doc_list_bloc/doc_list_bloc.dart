import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_7/domain/repo/form_7_repo.dart';
import 'bloc.dart';

class DocListBloc extends Bloc<DocListEvent, DocListState> {
  DocListState get initialState => DocListInitial();
  Form7Repo form7repo = Form7Repo();
  DocListBloc({required this.form7repo}) : super(DocListInitial()) {
    on<DocListEvent>((event, emit) async {
      if (event is DocListAttempt) {
        try {
          emit(DocListLoading());
          final documentListResponseModel =
              await form7repo.attemptDocList(event.code);
          if (documentListResponseModel.result == 1) {
            emit(DocListLoaded(
                documentListResponseModel: documentListResponseModel));
          } else if (documentListResponseModel.result == 0) {
            emit(DocListError(documentListResponseModel.message));
          } else {
            emit(const DocListException('error'));
          }
        } catch (e) {
          emit(DocListException(e.toString()));
        }
      }
    });
  }
}
