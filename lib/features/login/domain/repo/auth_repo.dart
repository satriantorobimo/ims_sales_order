import 'package:sales_order/features/login/data/auth_response_model.dart';
import 'package:sales_order/features/login/domain/api/auth_api.dart';

class AuthRepo {
  final AuthApi authApi = AuthApi();

  Future<AuthResponseModel?> attemptAuth(String username, String password) =>
      authApi.attemptAuth(username, password);
}
