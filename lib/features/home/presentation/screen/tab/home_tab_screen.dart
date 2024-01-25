import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/home/domain/repo/home_repo.dart';
import 'package:sales_order/features/home/presentation/widget/header_tab_widget.dart';
import 'package:sales_order/features/home/presentation/widget/notification_tab_widget.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/app_status_bloc/bloc.dart';
import '../../bloc/periode_bloc/bloc.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  AppStatusBloc appStatusBloc = AppStatusBloc(homeRepo: HomeRepo());
  PeriodeBloc periodeBloc = PeriodeBloc(homeRepo: HomeRepo());
  @override
  void initState() {
    appStatusBloc.add(const AppStatusAttempt());
    periodeBloc.add(const PeriodeAttempt());
    super.initState();
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
                          StringRouterUtil.reloginScreenTabRoute,
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
        body: RefreshIndicator(
          onRefresh: () async {
            appStatusBloc.add(const AppStatusAttempt());
            periodeBloc.add(const PeriodeAttempt());
          },
          child: SingleChildScrollView(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                //Main Content
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: [
                          //Header
                          const HeaderTabWidget(),
                          const SizedBox(height: 32),
                          //Status
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Application Status',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                BlocListener(
                                    bloc: appStatusBloc,
                                    listener: (_, AppStatusState state) {
                                      if (state is AppStatusLoading) {}
                                      if (state is AppStatusLoaded) {}
                                      if (state is AppStatusError) {
                                        GeneralUtil().showSnackBar(
                                            context, state.error!);
                                      }
                                      if (state is AppStatusException) {}
                                    },
                                    child: BlocBuilder(
                                        bloc: appStatusBloc,
                                        builder: (_, AppStatusState state) {
                                          if (state is AppStatusLoading) {
                                            return SizedBox(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.22,
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade100,
                                                child: GridView.count(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  crossAxisCount: 1,
                                                  mainAxisSpacing: 32,
                                                  crossAxisSpacing: 16,
                                                  childAspectRatio: 1.0 / 1.7,
                                                  shrinkWrap: true,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  children: List.generate(3,
                                                      (int index) {
                                                    return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          color: Colors
                                                              .grey.shade300,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                            Text(
                                                              '',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                            ),
                                                          ],
                                                        ));
                                                  }),
                                                ),
                                              ),
                                            );
                                          }
                                          if (state is AppStatusLoaded) {
                                            return SizedBox(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.22,
                                              child: Center(
                                                  child: GridView.count(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                crossAxisCount: 1,
                                                mainAxisSpacing: 32,
                                                crossAxisSpacing: 16,
                                                childAspectRatio: 1.0 / 1.7,
                                                shrinkWrap: true,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                children: List.generate(
                                                    state
                                                        .appStatusResponseModel
                                                        .data!
                                                        .length, (int index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          StringRouterUtil
                                                              .applicationFilterListScreenTabRoute,
                                                          arguments: state
                                                              .appStatusResponseModel
                                                              .data![index]
                                                              .applicationStatus);
                                                    },
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          color: state
                                                                      .appStatusResponseModel
                                                                      .data![
                                                                          index]
                                                                      .applicationStatus ==
                                                                  'APPROVE'
                                                              ? primaryColor
                                                              : state
                                                                          .appStatusResponseModel
                                                                          .data![
                                                                              index]
                                                                          .applicationStatus ==
                                                                      'HOLD'
                                                                  ? secondaryColor
                                                                  : thirdColor,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              state
                                                                  .appStatusResponseModel
                                                                  .data![index]
                                                                  .applicationStatus!,
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: state
                                                                              .appStatusResponseModel
                                                                              .data![
                                                                                  index]
                                                                              .applicationStatus ==
                                                                          'APPROVE'
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                            Text(
                                                              state
                                                                  .appStatusResponseModel
                                                                  .data![index]
                                                                  .applicationCount
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 40,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: state
                                                                              .appStatusResponseModel
                                                                              .data![
                                                                                  index]
                                                                              .applicationStatus ==
                                                                          'APPROVE'
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          ],
                                                        )),
                                                  );
                                                }),
                                              )),
                                            );
                                          }
                                          return SizedBox(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.22,
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor:
                                                  Colors.grey.shade100,
                                              child: GridView.count(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                crossAxisCount: 1,
                                                mainAxisSpacing: 32,
                                                crossAxisSpacing: 16,
                                                childAspectRatio: 1.0 / 1.7,
                                                shrinkWrap: true,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                children: List.generate(3,
                                                    (int index) {
                                                  return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            '',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                          ),
                                                        ],
                                                      ));
                                                }),
                                              ),
                                            ),
                                          );
                                        }))
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),
                          //New Application
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dashboard Data Approved',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                BlocListener(
                                    bloc: periodeBloc,
                                    listener: (_, PeriodeState state) {
                                      if (state is PeriodeLoading) {}
                                      if (state is PeriodeLoaded) {}
                                      if (state is PeriodeError) {
                                        GeneralUtil().showSnackBar(
                                            context, state.error!);
                                      }
                                      if (state is PeriodeException) {
                                        if (state.error == 'expired') {
                                          _showBottomExpired();
                                        } else {
                                          GeneralUtil().showSnackBar(context,
                                              'Terjadi Kesalahan Sistem');
                                        }
                                      }
                                    },
                                    child: BlocBuilder(
                                        bloc: periodeBloc,
                                        builder: (_, PeriodeState state) {
                                          if (state is PeriodeLoading) {
                                            return SizedBox(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade100,
                                                child: GridView.count(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  crossAxisCount: 1,
                                                  mainAxisSpacing: 24,
                                                  crossAxisSpacing: 16,
                                                  childAspectRatio: 1.0 / 2.0,
                                                  shrinkWrap: true,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  children: List.generate(3,
                                                      (int index) {
                                                    return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.05)),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1),
                                                              blurRadius: 6,
                                                              offset: const Offset(
                                                                  -6,
                                                                  4), // Shadow position
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          16.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),
                                                                  Text(
                                                                    '',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300),
                                                                  ),
                                                                  Text(
                                                                    '',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ));
                                                  }),
                                                ),
                                              ),
                                            );
                                          }
                                          if (state is PeriodeLoaded) {
                                            return SizedBox(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              child: Center(
                                                child: GridView.count(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  crossAxisCount: 1,
                                                  mainAxisSpacing: 24,
                                                  crossAxisSpacing: 16,
                                                  childAspectRatio: 1.0 / 2.0,
                                                  shrinkWrap: true,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  children: List.generate(
                                                      state
                                                          .dataPeriodeResponseModel
                                                          .data!
                                                          .length, (int index) {
                                                    return GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.05)),
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1),
                                                                blurRadius: 6,
                                                                offset: const Offset(
                                                                    -6,
                                                                    4), // Shadow position
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    Container(
                                                                  width: 109,
                                                                  height: 30,
                                                                  decoration: BoxDecoration(
                                                                      color: state.dataPeriodeResponseModel.data![index].periodName!.toUpperCase() == 'THIS YEAR'
                                                                          ? thirdColor
                                                                          : state.dataPeriodeResponseModel.data![index].periodName! == 'THIS QUARTER'
                                                                              ? primaryColor
                                                                              : secondaryColor,
                                                                      borderRadius: const BorderRadius.only(
                                                                        topRight:
                                                                            Radius.circular(18.0),
                                                                        bottomLeft:
                                                                            Radius.circular(8.0),
                                                                      )),
                                                                  child: Center(
                                                                    child: Text(
                                                                      state
                                                                          .dataPeriodeResponseModel
                                                                          .data![
                                                                              index]
                                                                          .periodName!,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          color: state.dataPeriodeResponseModel.data![index].periodName!.toUpperCase() == 'THIS YEAR' || state.dataPeriodeResponseModel.data![index].periodName! == 'THIS MONTH'
                                                                              ? Colors.black
                                                                              : Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 16.0,
                                                                    right: 16.0,
                                                                    top: 8.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      state
                                                                          .dataPeriodeResponseModel
                                                                          .data![
                                                                              index]
                                                                          .timePeriod!,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              21,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            8),
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              16),
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              secondaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(6)),
                                                                      child:
                                                                          Text(
                                                                        state
                                                                            .dataPeriodeResponseModel
                                                                            .data![index]
                                                                            .applicationCount
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    );
                                                  }),
                                                ),
                                              ),
                                            );
                                          }
                                          return SizedBox(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor:
                                                  Colors.grey.shade100,
                                              child: GridView.count(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                crossAxisCount: 1,
                                                mainAxisSpacing: 24,
                                                crossAxisSpacing: 16,
                                                childAspectRatio: 1.0 / 2.0,
                                                shrinkWrap: true,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                children: List.generate(3,
                                                    (int index) {
                                                  return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.05)),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                            blurRadius: 6,
                                                            offset: const Offset(
                                                                -6,
                                                                4), // Shadow position
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 16.0,
                                                                    right:
                                                                        16.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300),
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                Text(
                                                                  '',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300),
                                                                ),
                                                                Text(
                                                                  '',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ));
                                                }),
                                              ),
                                            ),
                                          );
                                        }))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //Notification
                const NotificationTabWidget()
              ],
            ),
          ),
        ));
  }
}
