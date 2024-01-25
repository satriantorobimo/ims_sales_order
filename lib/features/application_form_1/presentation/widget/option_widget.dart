import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';

import '../bloc/cancel_client_bloc/bloc.dart';

class OptionWidget {
  final bool isUsed;
  CancelClientBloc cancelClientBloc = CancelClientBloc(form1repo: Form1Repo());

  OptionWidget({required this.isUsed});
  void showBottomOption(context, String applicationNo) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding:
                        const EdgeInsets.only(top: 32.0, left: 24, right: 24),
                    child: Center(
                      child: Image.asset(
                        'assets/img/back.png',
                        width: 150,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 24.0, left: 24, right: 24, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Option',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Silahkan pilih option dibawah ini',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            StringRouterUtil.tabScreenTabRoute,
                            (route) => false);
                      },
                      child: Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child: Text('Kembali ke Home',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ),
                    const SizedBox(width: 16),
                    BlocListener(
                        bloc: cancelClientBloc,
                        listener: (_, CancelClientState state) {
                          if (state is CancelClientLoading) {}

                          if (state is CancelClientLoaded) {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                StringRouterUtil.tabScreenTabRoute,
                                (route) => false);
                          }
                          if (state is CancelClientError) {
                            GeneralUtil().showSnackBar(context, state.error!);
                          }
                          if (state is CancelClientException) {
                            GeneralUtil().showSnackBar(
                                context, 'Terjadi Kesalahan Sistem');
                          }
                        },
                        child: BlocBuilder(
                            bloc: cancelClientBloc,
                            builder: (_, CancelClientState state) {
                              if (state is CancelClientLoading) {
                                return const SizedBox(
                                  width: 200,
                                  height: 45,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (state is CancelClientLoaded) {
                                return InkWell(
                                  onTap: !isUsed
                                      ? null
                                      : () {
                                          cancelClientBloc.add(
                                              CancelClientAttempt(
                                                  applicationNo));
                                        },
                                  child: Container(
                                    width: 200,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: !isUsed
                                          ? const Color(0xFFE1E1E1)
                                          : thirdColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                        child: Text('Cancel Aplikasi',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: !isUsed
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                );
                              }
                              return InkWell(
                                onTap: !isUsed
                                    ? null
                                    : () {
                                        cancelClientBloc.add(
                                            CancelClientAttempt(applicationNo));
                                      },
                                child: Container(
                                  width: 200,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: !isUsed
                                        ? const Color(0xFFE1E1E1)
                                        : thirdColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: Text('Cancel Aplikasi',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: !isUsed
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w600))),
                                ),
                              );
                            })),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            );
          });
        });
  }
}
