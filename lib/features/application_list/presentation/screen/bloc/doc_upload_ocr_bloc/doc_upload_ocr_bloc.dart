import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_list/domain/repo/application_list_repo.dart';
import 'bloc.dart';

class DocUploadOCRBloc extends Bloc<DocUploadOCREvent, DocUploadOCRState> {
  DocUploadOCRState get initialState => DocUploadOCRInitial();
  ApplicationListRepo applicationListRepo = ApplicationListRepo();
  DocUploadOCRBloc({required this.applicationListRepo})
      : super(DocUploadOCRInitial()) {
    on<DocUploadOCREvent>((event, emit) async {
      if (event is DocUploadOCRAttempt) {
        try {
          emit(DocUploadOCRLoading());
          final documentUploadOCRResponseModel = await applicationListRepo
              .attemptDocUpload(event.documentUploadOCRRequestModel);
          if (documentUploadOCRResponseModel.result == 1) {
            emit(DocUploadOCRLoaded(
                documentUploadOCRResponseModel:
                    documentUploadOCRResponseModel));
          } else if (documentUploadOCRResponseModel.result == 0) {
            emit(DocUploadOCRError(documentUploadOCRResponseModel.message));
          } else {
            emit(const DocUploadOCRException('error'));
          }
        } catch (e) {
          emit(DocUploadOCRException(e.toString()));
        }
      }
    });
  }
}
