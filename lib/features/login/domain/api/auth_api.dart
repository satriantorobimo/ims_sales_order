import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_order/features/login/data/auth_response_model.dart';
import 'package:sales_order/utility/url_util.dart';

class AuthApi {
  AuthResponseModel authResponseModel = AuthResponseModel();

  UrlUtil urlUtil = UrlUtil();

  Future<AuthResponseModel> attemptAuth(
      String username, String password) async {
    final Map<String, String> header = urlUtil.getHeaderTypeForm();

    try {
      final res = await http.post(Uri.parse(urlUtil.getUrlLogin()),
          body: {
            'username': username,
            'password': password,
          },
          headers: header);
      if (res.statusCode == 200) {
        authResponseModel = AuthResponseModel.fromJson(jsonDecode(res.body));
        return authResponseModel;
      } else {
        authResponseModel = AuthResponseModel.fromJson(jsonDecode(res.body));
        throw authResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
