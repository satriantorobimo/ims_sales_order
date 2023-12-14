import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_4/domain/repo/form_4_repo.dart';
import 'bloc.dart';

class UpdateAssetDataBloc
    extends Bloc<UpdateAssetDataEvent, UpdateAssetDataState> {
  UpdateAssetDataState get initialState => UpdateAssetDataInitial();
  Form4Repo form4repo = Form4Repo();
  UpdateAssetDataBloc({required this.form4repo})
      : super(UpdateAssetDataInitial()) {
    on<UpdateAssetDataEvent>((event, emit) async {
      if (event is UpdateAssetDataAttempt) {
        try {
          emit(UpdateAssetDataLoading());
          final addClientResponseModel = await form4repo
              .attemptUpdateAssetData(event.updateAssetRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(UpdateAssetDataLoaded(
                addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(UpdateAssetDataError(addClientResponseModel.message));
          } else {
            emit(const UpdateAssetDataException('error'));
          }
        } catch (e) {
          emit(UpdateAssetDataException(e.toString()));
        }
      }
    });
  }
}
