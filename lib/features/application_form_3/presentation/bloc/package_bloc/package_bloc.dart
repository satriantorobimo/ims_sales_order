import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_3/domain/repo/form_3_repo.dart';
import 'bloc.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  PackageState get initialState => PackageInitial();
  Form3Repo form3repo = Form3Repo();
  PackageBloc({required this.form3repo}) : super(PackageInitial()) {
    on<PackageEvent>((event, emit) async {
      if (event is PackageAttempt) {
        try {
          emit(PackageLoading());
          final lookUpPackageModel =
              await form3repo.attemptLookupPackage(event.code);
          if (lookUpPackageModel.result == 1) {
            emit(PackageLoaded(lookUpPackageModel: lookUpPackageModel));
          } else if (lookUpPackageModel.result == 0) {
            emit(PackageError(lookUpPackageModel.message));
          } else {
            emit(const PackageException('error'));
          }
        } catch (e) {
          emit(PackageException(e.toString()));
        }
      }
    });
  }
}
