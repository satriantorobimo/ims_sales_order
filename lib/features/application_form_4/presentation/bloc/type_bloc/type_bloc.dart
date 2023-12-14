import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_4/domain/repo/form_4_repo.dart';
import 'bloc.dart';

class TypeBloc extends Bloc<TypeEvent, TypeState> {
  TypeState get initialState => TypeInitial();
  Form4Repo form4repo = Form4Repo();
  TypeBloc({required this.form4repo}) : super(TypeInitial()) {
    on<TypeEvent>((event, emit) async {
      if (event is TypeAttempt) {
        try {
          emit(TypeLoading());
          final lookUpMerkModel = await form4repo.attemptLookupType(event.code);
          if (lookUpMerkModel.result == 1) {
            emit(TypeLoaded(lookUpMerkModel: lookUpMerkModel));
          } else if (lookUpMerkModel.result == 0) {
            emit(TypeError(lookUpMerkModel.message));
          } else {
            emit(const TypeException('error'));
          }
        } catch (e) {
          emit(TypeException(e.toString()));
        }
      }
    });
  }
}
