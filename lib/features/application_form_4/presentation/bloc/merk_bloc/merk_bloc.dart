import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_4/domain/repo/form_4_repo.dart';
import 'bloc.dart';

class MerkBloc extends Bloc<MerkEvent, MerkState> {
  MerkState get initialState => MerkInitial();
  Form4Repo form4repo = Form4Repo();
  MerkBloc({required this.form4repo}) : super(MerkInitial()) {
    on<MerkEvent>((event, emit) async {
      if (event is MerkAttempt) {
        try {
          emit(MerkLoading());
          final lookUpMerkModel = await form4repo.attemptLookupMerk(event.code);
          if (lookUpMerkModel.result == 1) {
            emit(MerkLoaded(lookUpMerkModel: lookUpMerkModel));
          } else if (lookUpMerkModel.result == 0) {
            emit(MerkError(lookUpMerkModel.message));
          } else {
            emit(const MerkException('error'));
          }
        } catch (e) {
          emit(MerkException(e.toString()));
        }
      }
    });
  }
}
