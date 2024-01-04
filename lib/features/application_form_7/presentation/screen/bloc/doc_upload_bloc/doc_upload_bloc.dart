import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_7/domain/repo/form_7_repo.dart';
import 'bloc.dart';

class DocUploadBloc extends Bloc<DocUploadEvent, DocUploadState> {
  DocUploadState get initialState => DocUploadInitial();
  Form7Repo form7repo = Form7Repo();
  DocUploadBloc({required this.form7repo}) : super(DocUploadInitial()) {
    on<DocUploadEvent>((event, emit) async {
      if (event is DocUploadAttempt) {
        try {
          emit(DocUploadLoading());
          final addClientResponseModel = await form7repo
              .attemptDocUpload(event.documentUploadRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(DocUploadLoaded(
                addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(DocUploadError(addClientResponseModel.message));
          } else {
            emit(const DocUploadException('error'));
          }
        } catch (e) {
          emit(DocUploadException(e.toString()));
        }
      }
    });
  }
}
