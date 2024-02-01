import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/empty_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_5/data/look_up_insurance_package_model.dart';
import 'package:sales_order/features/application_form_5/data/update_fee_request_model.dart';
import 'package:sales_order/features/application_form_5/data/update_tnc_request_model.dart';
import 'package:sales_order/features/application_form_5/domain/repo/form_5_repo.dart';
import 'package:sales_order/features/application_form_5/presentation/bloc/fee_data_bloc/bloc.dart';
import 'package:sales_order/features/application_form_5/presentation/bloc/insurance_bloc/bloc.dart';
import 'package:sales_order/features/application_form_5/presentation/bloc/tnc_data_bloc/bloc.dart';
import 'package:sales_order/features/application_form_5/presentation/bloc/update_fee_bloc/bloc.dart';
import 'package:sales_order/features/application_form_5/presentation/bloc/update_tnc_bloc/bloc.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:sales_order/features/application_form_5/data/application_fee_detail_model.dart'
    as fee;
import 'package:shimmer/shimmer.dart';

class ApplicationForm5ViewMobileScreen extends StatefulWidget {
  const ApplicationForm5ViewMobileScreen(
      {super.key, required this.applicationNo});
  final String applicationNo;

  @override
  State<ApplicationForm5ViewMobileScreen> createState() =>
      _ApplicationForm5ViewMobileScreenState();
}

class _ApplicationForm5ViewMobileScreenState
    extends State<ApplicationForm5ViewMobileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tabs = const [
    Tab(text: 'Fee Data'),
    Tab(text: 'T&C'),
  ];
  String condition = 'ARREAR';
  List<fee.Data> data = [];
  int selectIndexInsurance = 10000;
  String selectInsurance = '';
  String selectInsuranceCode = '';
  int tenor = 0;
  FeeDataBloc feeDataBloc = FeeDataBloc(form5repo: Form5Repo());
  TncDataBloc tncDataBloc = TncDataBloc(form5repo: Form5Repo());

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    feeDataBloc.add(FeeDataAttempt(widget.applicationNo));
    tncDataBloc.add(TncDataAttempt(widget.applicationNo));
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 24, top: 16, bottom: 8),
              child: InkWell(
                onTap: () {
                  OptionWidget(isUsed: false).showBottomOption(context, '');
                },
                child: const Icon(
                  Icons.more_vert_rounded,
                  size: 28,
                ),
              ))
        ],
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'T&C',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
            child: Container(
              height: kToolbarHeight - 8.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: primaryColor),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: _tabs,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [feedata(context), tnc(context)],
            ),
          )
        ],
      ),
    );
  }

  Widget feedata(BuildContext context) {
    return BlocListener(
        bloc: feeDataBloc,
        listener: (_, FeeDataState state) {
          if (state is FeeDataLoading) {}
          if (state is FeeDataLoaded) {
            data = state.applicationFeeDetailModel.data!;
          }
          if (state is FeeDataError) {}
          if (state is FeeDataException) {}
        },
        child: BlocBuilder(
            bloc: feeDataBloc,
            builder: (_, FeeDataState state) {
              if (state is FeeDataLoading) {
                return _loading();
              }
              if (state is FeeDataLoaded) {
                return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 16);
                    },
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${index + 1}. Biaya Admin',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.1)),
                                      color: const Color(0xFFFAF9F9),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(
                                              -6, 4), // Shadow position
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        GeneralUtil.convertToIdr(
                                            data[index].feeAmount, 2),
                                        style: const TextStyle(
                                            color: Color(0xFF6E6E6E),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Payment Type',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 55,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.1)),
                                      color: const Color(0xFFFAF9F9),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(
                                              -6, 4), // Shadow position
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        data[index].feePaymentType!,
                                        style: const TextStyle(
                                            color: Color(0xFF6E6E6E),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ));
                    });
              }
              return _loading();
            }));
  }

  Widget tnc(BuildContext context) {
    return BlocListener(
        bloc: tncDataBloc,
        listener: (_, TncDataState state) {
          if (state is TncDataLoading) {}
          if (state is TncDataLoaded) {
            condition =
                state.tncDataDetailResponseModel.data![0].firstPaymentTypeDesc!;
            tenor = state.tncDataDetailResponseModel.data![0].tenor!;

            if (state
                    .tncDataDetailResponseModel.data![0].insurancePackageCode !=
                null) {
              selectInsuranceCode = state
                  .tncDataDetailResponseModel.data![0].insurancePackageCode!;
              selectInsurance = state
                  .tncDataDetailResponseModel.data![0].insurancePackageDesc!;
            }
          }
          if (state is TncDataError) {}
          if (state is TncDataException) {}
        },
        child: BlocBuilder(
            bloc: tncDataBloc,
            builder: (_, TncDataState state) {
              if (state is TncDataLoading) {
                return _loading();
              }
              if (state is TncDataLoaded) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Type',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 48,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 35,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: condition == 'ARREAR'
                                            ? primaryColor
                                            : const Color(0xFFE1E1E1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                          child: Text('ARREAR',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 35,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: condition == 'ADVANCE'
                                            ? primaryColor
                                            : const Color(0xFFE1E1E1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                          child: Text('ADVANCE',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Flat Rate (p.a)',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                                color: const Color(0xFFFAF9F9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${state.tncDataDetailResponseModel.data![0].interestFlatRate}',
                                  style: const TextStyle(
                                      color: Color(0xFF6E6E6E),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DP (%)',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                                color: const Color(0xFFFAF9F9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${state.tncDataDetailResponseModel.data![0].dpPct}',
                                  style: const TextStyle(
                                      color: Color(0xFF6E6E6E),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DP Amount',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                                color: const Color(0xFFFAF9F9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  GeneralUtil.convertToIdr(
                                      state.tncDataDetailResponseModel.data![0]
                                          .dpAmount,
                                      2),
                                  style: const TextStyle(
                                      color: Color(0xFF6E6E6E),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Installment Amount',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                                color: const Color(0xFFFAF9F9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  GeneralUtil.convertToIdr(
                                      state.tncDataDetailResponseModel.data![0]
                                          .installmentAmount,
                                      2),
                                  style: const TextStyle(
                                      color: Color(0xFF6E6E6E),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tenor',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                                color: const Color(0xFFFAF9F9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${state.tncDataDetailResponseModel.data![0].tenor}',
                                  style: const TextStyle(
                                      color: Color(0xFF6E6E6E),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Insurance Package',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' *',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                                color: const Color(0xFFFAF9F9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  selectInsurance,
                                  style: const TextStyle(
                                      color: Color(0xFF6E6E6E),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                      child: Text('PREV',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600))),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context,
                                      StringRouterUtil
                                          .applicationForm7ViewScreenMobileRoute,
                                      arguments: widget.applicationNo);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: thirdColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                      child: Text('NEXT',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600))),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return _loading();
            }));
  }

  Widget _loading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) {
            return const Padding(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              child: Divider(),
            );
          },
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: double.infinity,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(-6, 4), // Shadow position
                  ),
                ],
              ),
            );
          }),
    );
  }
}
