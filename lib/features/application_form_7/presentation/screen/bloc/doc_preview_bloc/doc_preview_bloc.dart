import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_7/domain/repo/form_7_repo.dart';
import 'bloc.dart';

class DocPreviewBloc extends Bloc<DocPreviewEvent, DocPreviewState> {
  DocPreviewState get initialState => DocPreviewInitial();
  Form7Repo form7repo = Form7Repo();
  DocPreviewBloc({required this.form7repo}) : super(DocPreviewInitial()) {
    on<DocPreviewEvent>((event, emit) async {
      if (event is DocPreviewAttempt) {
        try {
          emit(DocPreviewLoading());
          final documentPreviewModel = await form7repo
              .attemptDocPreview(event.documentPreviewRequestModel);
          if (documentPreviewModel.statusCode == 200) {
            emit(DocPreviewLoaded(documentPreviewModel: documentPreviewModel));
          } else {
            emit(const DocPreviewException('error'));
          }
        } catch (e) {
          emit(DocPreviewException(e.toString()));
        }
      }
    });
  }
}
