import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/login/data/auth_response_model.dart';
import 'package:sales_order/features/login/domain/repo/auth_repo.dart';
import 'package:sales_order/features/login/presentation/bloc/auth_bloc/bloc.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/database_helper.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/string_router_util.dart';

class FormReloginWidget extends StatefulWidget {
  const FormReloginWidget({super.key});

  @override
  State<FormReloginWidget> createState() => _FormReloginWidgetState();
}

class _FormReloginWidgetState extends State<FormReloginWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isShow = true, isLoading = false;
  AuthBloc authBloc = AuthBloc(authRepo: AuthRepo());

  void _userPassNotFilled() {
    showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Center(
            child: Container(
              decoration: BoxDecoration(
                color: thirdColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Username/password tidak boleh kosong',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF575551)),
                ),
                SizedBox(height: 8),
                Text(
                  'Mohon periksa ulang dan coba lagi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF575551)),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                      child: Text('Close',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600))),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _errorSystem() {
    showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Center(
            child: Container(
              decoration: BoxDecoration(
                color: thirdColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Oops terjadi kesalahan system',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF575551)),
                ),
                SizedBox(height: 8),
                Text(
                  'Mohon ulangin beberapa saat lagi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF575551)),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                      child: Text('Close',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600))),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _invalidUsernamePassword() {
    showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Center(
            child: Container(
              decoration: BoxDecoration(
                color: thirdColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Invalid Username or Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF575551)),
                ),
                SizedBox(height: 8),
                Text(
                  'Mohon periksa ulang dan coba lagi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF575551)),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                      child: Text('Close',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600))),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _processDb(Datalist datalist) async {
    await DatabaseHelper.deleteUser();
    await DatabaseHelper.insertUser(datalist);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 6,
          shadowColor: Colors.grey.withOpacity(0.4),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(width: 1.0, color: Color(0xFFEAEAEA))),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: 'Email',
                isDense: true,
                contentPadding: const EdgeInsets.all(24),
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                )),
          ),
        ),
        const SizedBox(height: 24),
        Stack(
          alignment: const Alignment(0, 0),
          children: [
            Material(
              elevation: 6,
              shadowColor: Colors.grey.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(width: 1.0, color: Color(0xFFEAEAEA))),
              child: TextFormField(
                controller: _passController,
                obscureText: _isShow,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Password',
                    isDense: true,
                    contentPadding: const EdgeInsets.all(24),
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    )),
              ),
            ),
            Positioned(
              right: 16,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isShow = !_isShow;
                  });
                },
                child: Icon(
                  _isShow
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 40),
        BlocListener(
            bloc: authBloc,
            listener: (_, AuthState state) {
              if (state is AuthLoading) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is AuthLoaded) {
                if (state.authResponseModel.datalist != null) {
                  _processDb(state.authResponseModel.datalist![0])
                      .then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    SharedPrefUtil.saveSharedString(
                        'token', state.authResponseModel.token!);
                    Navigator.pushNamedAndRemoveUntil(context,
                        StringRouterUtil.tabScreenTabRoute, (route) => false);
                  });
                } else {
                  _invalidUsernamePassword();
                }
              }
              if (state is AuthError) {
                _invalidUsernamePassword();
                setState(() {
                  isLoading = false;
                });
              }
              if (state is AuthException) {
                _errorSystem();
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: BlocBuilder(
                bloc: authBloc,
                builder: (_, AuthState state) {
                  return isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 45,
                            height: 45,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            if (_emailController.text.isEmpty ||
                                _emailController.text == '' ||
                                _passController.text.isEmpty ||
                                _passController.text == '') {
                              _userPassNotFilled();
                            } else {
                              authBloc.add(AuthAttempt(
                                  username: _emailController.text,
                                  password: _passController.text));
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 66,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                                child: Text('Continue',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600))),
                          ),
                        );
                }))
      ],
    );
  }
}
