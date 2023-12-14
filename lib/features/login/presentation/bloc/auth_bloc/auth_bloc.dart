import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/login/domain/repo/auth_repo.dart';
import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthState get initialState => AuthInitial();
  AuthRepo authRepo = AuthRepo();
  AuthBloc({required this.authRepo}) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthAttempt) {
        try {
          emit(AuthLoading());
          final authResponseModel =
              await authRepo.attemptAuth(event.username, event.password);
          if (authResponseModel!.status == 1) {
            emit(AuthLoaded(authResponseModel: authResponseModel));
          } else if (authResponseModel.status == 0) {
            emit(AuthError(authResponseModel.message));
          } else {
            emit(const AuthException('error'));
          }
        } catch (e) {
          emit(AuthException(e.toString()));
        }
      }
    });
  }
}
