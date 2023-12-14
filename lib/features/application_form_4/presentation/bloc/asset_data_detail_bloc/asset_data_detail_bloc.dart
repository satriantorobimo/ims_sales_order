import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_4/domain/repo/form_4_repo.dart';
import 'bloc.dart';

class AssetDataDetailBloc
    extends Bloc<AssetDataDetailEvent, AssetDataDetailState> {
  AssetDataDetailState get initialState => AssetDataDetailInitial();
  Form4Repo form4repo = Form4Repo();
  AssetDataDetailBloc({required this.form4repo})
      : super(AssetDataDetailInitial()) {
    on<AssetDataDetailEvent>((event, emit) async {
      if (event is AssetDataDetailAttempt) {
        try {
          emit(AssetDataDetailLoading());
          final assetDetailResponseModel =
              await form4repo.attemptGetAssetData(event.code);
          if (assetDetailResponseModel.result == 1) {
            emit(AssetDataDetailLoaded(
                assetDetailResponseModel: assetDetailResponseModel));
          } else if (assetDetailResponseModel.result == 0) {
            emit(AssetDataDetailError(assetDetailResponseModel.message));
          } else {
            emit(const AssetDataDetailException('error'));
          }
        } catch (e) {
          emit(AssetDataDetailException(e.toString()));
        }
      }
    });
  }
}
