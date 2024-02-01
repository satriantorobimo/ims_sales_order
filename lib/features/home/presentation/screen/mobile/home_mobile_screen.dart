import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/home/domain/repo/home_repo.dart';
import 'package:sales_order/features/home/presentation/widget/header_tab_widget.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/database_helper.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/app_status_bloc/bloc.dart';
import '../../bloc/periode_bloc/bloc.dart';

class HomeMobileScreen extends StatefulWidget {
  const HomeMobileScreen({super.key});

  @override
  State<HomeMobileScreen> createState() => _HomeMobileScreenState();
}

class _HomeMobileScreenState extends State<HomeMobileScreen> {
  AppStatusBloc appStatusBloc = AppStatusBloc(homeRepo: HomeRepo());
  PeriodeBloc periodeBloc = PeriodeBloc(homeRepo: HomeRepo());

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final data = await DatabaseHelper.getUserData();

    appStatusBloc.add(AppStatusAttempt(data[0]['uid']));
    periodeBloc.add(PeriodeAttempt(data[0]['uid']));
  }

  Future<void> _showBottomExpired() {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
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
                        'assets/img/expired.png',
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
                        'Your Session Has Expired',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Please Relogin',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          StringRouterUtil.reloginScreenMobileRoute,
                          (route) => false);
                    },
                    child: Container(
                      width: 200,
                      height: 45,
                      decoration: BoxDecoration(
                        color: thirdColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Text('RELOGIN',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(top: 40.0, bottom: 16, left: 16, right: 16),
              child: HeaderTabWidget(),
            ),
            Expanded(
                child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    'Application Status',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocListener(
                    bloc: appStatusBloc,
                    listener: (_, AppStatusState state) {
                      if (state is AppStatusLoading) {}
                      if (state is AppStatusLoaded) {}
                      if (state is AppStatusError) {
                        GeneralUtil().showSnackBar(context, state.error!);
                      }
                      if (state is AppStatusException) {}
                    },
                    child: BlocBuilder(
                        bloc: appStatusBloc,
                        builder: (_, AppStatusState state) {
                          if (state is AppStatusLoading) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.only(top: 4, bottom: 4),
                                    );
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: double.infinity,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade300,
                                      ),
                                    );
                                  }),
                            );
                          }
                          if (state is AppStatusLoaded) {
                            return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                itemCount:
                                    state.appStatusResponseModel.data!.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 2, bottom: 4),
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context,
                                          StringRouterUtil
                                              .applicationFilterListScreenMobileRoute,
                                          arguments: state
                                              .appStatusResponseModel
                                              .data![index]
                                              .applicationStatus);
                                    },
                                    child: Container(
                                        width: double.infinity,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: state
                                                      .appStatusResponseModel
                                                      .data![index]
                                                      .applicationStatus ==
                                                  'APPROVE'
                                              ? primaryColor
                                              : state
                                                          .appStatusResponseModel
                                                          .data![index]
                                                          .applicationStatus ==
                                                      'HOLD'
                                                  ? secondaryColor
                                                  : thirdColor,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              state
                                                  .appStatusResponseModel
                                                  .data![index]
                                                  .applicationStatus!,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: state
                                                              .appStatusResponseModel
                                                              .data![index]
                                                              .applicationStatus ==
                                                          'APPROVE'
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              state.appStatusResponseModel
                                                  .data![index].applicationCount
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: state
                                                              .appStatusResponseModel
                                                              .data![index]
                                                              .applicationStatus ==
                                                          'APPROVE'
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ],
                                        )),
                                  );
                                });
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: 3,
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 4, bottom: 4),
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: double.infinity,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade300,
                                    ),
                                  );
                                }),
                          );
                        })),
                const SizedBox(
                  height: 16,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    'Dashboard Data Approved',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocListener(
                    bloc: periodeBloc,
                    listener: (_, PeriodeState state) {
                      if (state is PeriodeLoading) {}
                      if (state is PeriodeLoaded) {}
                      if (state is PeriodeError) {
                        GeneralUtil().showSnackBar(context, state.error!);
                      }
                      if (state is PeriodeException) {
                        if (state.error == 'expired') {
                          _showBottomExpired();
                        } else {
                          GeneralUtil().showSnackBar(
                              context, 'Terjadi Kesalahan Sistem');
                        }
                      }
                    },
                    child: BlocBuilder(
                        bloc: periodeBloc,
                        builder: (_, PeriodeState state) {
                          if (state is PeriodeLoading) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: ListView.separated(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.only(top: 4, bottom: 4),
                                    );
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: double.infinity,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade300,
                                      ),
                                    );
                                  }),
                            );
                          }
                          if (state is PeriodeLoaded) {
                            return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, bottom: 32),
                                itemCount:
                                    state.dataPeriodeResponseModel.data!.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 2, bottom: 4),
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      height: 80,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.05)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 6,
                                            offset: const Offset(
                                                -6, 4), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              width: 109,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: state
                                                              .dataPeriodeResponseModel
                                                              .data![index]
                                                              .periodName!
                                                              .toUpperCase() ==
                                                          'THIS YEAR'
                                                      ? thirdColor
                                                      : state
                                                                  .dataPeriodeResponseModel
                                                                  .data![index]
                                                                  .periodName! ==
                                                              'THIS QUARTER'
                                                          ? primaryColor
                                                          : secondaryColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(18.0),
                                                    bottomLeft:
                                                        Radius.circular(8.0),
                                                  )),
                                              child: Center(
                                                child: Text(
                                                  state.dataPeriodeResponseModel
                                                      .data![index].periodName!,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: state
                                                                      .dataPeriodeResponseModel
                                                                      .data![
                                                                          index]
                                                                      .periodName!
                                                                      .toUpperCase() ==
                                                                  'THIS YEAR' ||
                                                              state
                                                                      .dataPeriodeResponseModel
                                                                      .data![
                                                                          index]
                                                                      .periodName! ==
                                                                  'THIS MONTH'
                                                          ? Colors.black
                                                          : Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, right: 16.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  state.dataPeriodeResponseModel
                                                      .data![index].timePeriod!,
                                                  style: const TextStyle(
                                                      fontSize: 21,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: secondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  child: Text(
                                                    state
                                                        .dataPeriodeResponseModel
                                                        .data![index]
                                                        .applicationCount
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ));
                                });
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: ListView.separated(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                shrinkWrap: true,
                                itemCount: 3,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 4, bottom: 4),
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: double.infinity,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade300,
                                    ),
                                  );
                                }),
                          );
                        }))
              ],
            ))

            // ))
          ],
        ));
  }
}
