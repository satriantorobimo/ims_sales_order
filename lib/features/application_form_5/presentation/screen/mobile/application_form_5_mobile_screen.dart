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

class ApplicationForm5MobileScreen extends StatefulWidget {
  const ApplicationForm5MobileScreen(
      {super.key, required this.updateTncRequestModel});
  final UpdateTncRequestModel updateTncRequestModel;

  @override
  State<ApplicationForm5MobileScreen> createState() =>
      _ApplicationForm5MobileScreenState();
}

class _ApplicationForm5MobileScreenState
    extends State<ApplicationForm5MobileScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;
  final _tabs = const [
    Tab(text: 'Fee Data'),
    Tab(text: 'T&C'),
  ];
  String condition = 'ARREAR';
  List<String> feeType = ['FULL PAID', 'CAPITALIZE', 'REDUCE'];
  List<fee.Data> data = [];
  bool isLoading = false;
  int selectIndexInsurance = 10000;
  String selectInsurance = '';
  String selectInsuranceCode = '';
  int tenor = 0;
  List<UpdateFeeRequestModel> updateFee = [];
  UpdateTncRequestModel updateTncRequestModel = UpdateTncRequestModel();

  InsuranceBloc insuranceBloc = InsuranceBloc(form5repo: Form5Repo());
  FeeDataBloc feeDataBloc = FeeDataBloc(form5repo: Form5Repo());
  TncDataBloc tncDataBloc = TncDataBloc(form5repo: Form5Repo());
  UpdateTncBloc updateTncBloc = UpdateTncBloc(form5repo: Form5Repo());
  UpdateFeeBloc updateFeeBloc = UpdateFeeBloc(form5repo: Form5Repo());

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    insuranceBloc.add(const InsuranceAttempt(''));
    feeDataBloc
        .add(FeeDataAttempt(widget.updateTncRequestModel.pApplicationNo!));
    tncDataBloc
        .add(TncDataAttempt(widget.updateTncRequestModel.pApplicationNo!));
    super.initState();
  }

  Future<void> _showBottomInsurance(
      LookUpInsurancePackageModel lookUpInsurancePackageModel) {
    List<Data> tempList = [];
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, left: 8, right: 8),
                      child: Text(
                        'Insurance',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Material(
                        elevation: 6,
                        shadowColor: Colors.grey.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                width: 1.0, color: Color(0xFFEAEAEA))),
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setStates(() {
                                tempList = lookUpInsurancePackageModel.data!
                                    .where((item) => item.packageName!
                                        .toUpperCase()
                                        .contains(value.toUpperCase()))
                                    .toList();
                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'Search',
                                isDense: true,
                                contentPadding: const EdgeInsets.all(24),
                                hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.5)),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16),
                          itemCount: tempList.isNotEmpty
                              ? tempList.length
                              : lookUpInsurancePackageModel.data!.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 4, bottom: 4),
                              child: Divider(),
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (selectIndexInsurance == index) {
                                    selectInsurance = '';
                                    selectInsuranceCode = '';
                                    selectIndexInsurance = 1000;
                                  } else {
                                    selectInsurance = tempList.isNotEmpty
                                        ? tempList[index].packageName!
                                        : lookUpInsurancePackageModel
                                            .data![index].packageName!;
                                    selectInsuranceCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpInsurancePackageModel
                                            .data![index].code!;
                                    selectIndexInsurance = index;
                                  }
                                });
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    tempList.isNotEmpty
                                        ? tempList[index].packageName!
                                        : lookUpInsurancePackageModel
                                            .data![index].packageName!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  selectIndexInsurance == index
                                      ? const Icon(Icons.check_rounded,
                                          color: primaryColor)
                                      : Container()
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> _showBottomFeeType(int indexes) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 32.0, left: 24, right: 24),
                  child: Text(
                    'Fee Type',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                ),
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 24),
                      itemCount: feeType.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: Divider(),
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              data[indexes].feePaymentType = feeType[index];
                            });
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                feeType[index],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              data[indexes].feePaymentType == feeType[index]
                                  ? const Icon(Icons.check_rounded,
                                      color: primaryColor)
                                  : Container()
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: InkWell(
                onTap: () {
                  OptionWidget(isUsed: true).showBottomOption(
                      context, widget.updateTncRequestModel.pApplicationNo!);
                },
                child: Row(
                  children: const [
                    SizedBox(width: 8),
                    Icon(
                      Icons.more_vert_rounded,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                  ],
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
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.only(
          //         left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
          //     child:
          //         _tabController.index == 0 ? tnc(context) : feedata(context),
          //   ),
          // )
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
                return Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 16),
                          child: Container(
                            width: double.infinity,
                            height: 2,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        );
                      },
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
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
                                      data[index]
                                          .feeDesc!
                                          .capitalizeOnlyFirstLater(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.1)),
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
                                    Stack(
                                      children: [
                                        InkWell(
                                          onTap: data[index].isCalculated == '1'
                                              ? null
                                              : () {
                                                  _showBottomFeeType(index);
                                                },
                                          child: Container(
                                            height: 55,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.1)),
                                              color: data[index].isCalculated ==
                                                      '1'
                                                  ? const Color(0xFFFAF9F9)
                                                  : Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
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
                                                style: TextStyle(
                                                    color: data[index]
                                                                .isCalculated ==
                                                            '1'
                                                        ? const Color(
                                                            0xFF6E6E6E)
                                                        : Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 16,
                                          top: 14,
                                          child: data[index].isCalculated == '1'
                                              ? Container()
                                              : const Icon(
                                                  Icons.search_rounded,
                                                  color: Color(0xFF3D3D3D),
                                                ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ));
                      }),
                );
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
            // setState(() {
            updateTncRequestModel.pApplicationNo =
                widget.updateTncRequestModel.pApplicationNo;
            updateTncRequestModel.pInsurancePackageCode =
                state.tncDataDetailResponseModel.data![0].insurancePackageCode!;
            updateTncRequestModel.pPaymentType =
                state.tncDataDetailResponseModel.data![0].firstPaymentTypeDesc!;

            updateTncRequestModel.pTenor =
                state.tncDataDetailResponseModel.data![0].tenor!;
            // });
            if (state
                    .tncDataDetailResponseModel.data![0].insurancePackageCode !=
                null) {
              // setState(() {
              selectInsuranceCode = state
                  .tncDataDetailResponseModel.data![0].insurancePackageCode!;
              selectInsurance = state
                  .tncDataDetailResponseModel.data![0].insurancePackageDesc!;
              // });
              log(state
                  .tncDataDetailResponseModel.data![0].insurancePackageCode!);
              log(state
                  .tncDataDetailResponseModel.data![0].insurancePackageDesc!);
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
                        left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'First Payment Type',
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
                                    onTap: state.tncDataDetailResponseModel
                                                .data![0].isEditable ==
                                            '1'
                                        ? null
                                        : () {
                                            setState(() {
                                              condition = 'ARREAR';
                                            });
                                          },
                                    child: Container(
                                      height: 35,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: state
                                                    .tncDataDetailResponseModel
                                                    .data![0]
                                                    .firstPaymentTypeDesc ==
                                                'ARREAR'
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
                                    onTap: state.tncDataDetailResponseModel
                                                .data![0].isEditable ==
                                            '1'
                                        ? null
                                        : () {
                                            setState(() {
                                              condition = 'ADVANCE';
                                            });
                                          },
                                    child: Container(
                                      height: 35,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: state
                                                    .tncDataDetailResponseModel
                                                    .data![0]
                                                    .firstPaymentTypeDesc ==
                                                'ADVANCE'
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
                                alignment: Alignment.centerLeft,
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
                                alignment: Alignment.centerLeft,
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
                                alignment: Alignment.centerLeft,
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
                            Stack(
                              alignment: const Alignment(0, 0),
                              children: [
                                BlocListener(
                                    bloc: insuranceBloc,
                                    listener: (_, InsuranceState state2) {
                                      if (state2 is InsuranceLoading) {}
                                      if (state2 is InsuranceLoaded) {}
                                      if (state2 is InsuranceError) {}
                                      if (state2 is InsuranceException) {}
                                    },
                                    child: BlocBuilder(
                                        bloc: insuranceBloc,
                                        builder: (_, InsuranceState state2) {
                                          if (state2 is InsuranceLoading) {}
                                          if (state2 is InsuranceLoaded) {
                                            return InkWell(
                                              onTap: () {
                                                _showBottomInsurance(state2
                                                    .lookUpInsurancePackageModel);
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.1)),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                      blurRadius: 6,
                                                      offset: const Offset(-6,
                                                          4), // Shadow position
                                                    ),
                                                  ],
                                                ),
                                                padding: const EdgeInsets.only(
                                                    left: 16.0, right: 16.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    selectInsurance == '' &&
                                                            state
                                                                    .tncDataDetailResponseModel
                                                                    .data![0]
                                                                    .insurancePackageDesc! ==
                                                                ''
                                                        ? 'Select Insurance'
                                                        : selectInsurance == ''
                                                            ? state
                                                                .tncDataDetailResponseModel
                                                                .data![0]
                                                                .insurancePackageDesc!
                                                            : selectInsurance,
                                                    style: TextStyle(
                                                        color: selectInsurance ==
                                                                    '' &&
                                                                state
                                                                        .tncDataDetailResponseModel
                                                                        .data![
                                                                            0]
                                                                        .insurancePackageDesc! ==
                                                                    ''
                                                            ? Colors.grey
                                                                .withOpacity(
                                                                    0.5)
                                                            : Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          return Container(
                                            width: double.infinity,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.1)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
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
                                                '',
                                                style: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          );
                                        })),
                                const Positioned(
                                  right: 16,
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFF3D3D3D),
                                  ),
                                )
                              ],
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
                                      MediaQuery.of(context).size.width * 0.44,
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
                              MultiBlocListener(
                                  listeners: [
                                    BlocListener(
                                        bloc: updateTncBloc,
                                        listener: (_, UpdateTncState state) {
                                          if (state is UpdateTncLoading) {}
                                          if (state is UpdateTncLoaded) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pushNamed(
                                                context,
                                                StringRouterUtil
                                                    .applicationForm7ScreenMobileRoute,
                                                arguments: widget
                                                    .updateTncRequestModel
                                                    .pApplicationNo);
                                          }
                                          if (state is UpdateTncError) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            GeneralUtil().showSnackBar(
                                                context, state.error!);
                                          }
                                          if (state is UpdateTncException) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        }),
                                    BlocListener(
                                        bloc: updateFeeBloc,
                                        listener: (_, UpdateFeeState state) {
                                          if (state is UpdateFeeLoading) {}
                                          if (state is UpdateFeeLoaded) {
                                            updateTncBloc.add(UpdateTncAttempt(
                                                UpdateTncRequestModel(
                                                    pApplicationNo: widget
                                                        .updateTncRequestModel
                                                        .pApplicationNo,
                                                    pInsurancePackageCode:
                                                        selectInsuranceCode,
                                                    pPaymentType: condition,
                                                    pTenor: tenor)));
                                          }
                                          if (state is UpdateFeeError) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            GeneralUtil().showSnackBar(
                                                context, state.error!);
                                          }
                                          if (state is UpdateFeeException) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        })
                                  ],
                                  child: isLoading
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.44,
                                          height: 45,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            if (selectInsurance == '' &&
                                                state
                                                        .tncDataDetailResponseModel
                                                        .data![0]
                                                        .insurancePackageDesc! ==
                                                    '') {
                                              EmptyWidget()
                                                  .showBottomEmpty(context);
                                            } else {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              for (int i = 0;
                                                  i < data.length;
                                                  i++) {
                                                updateFee.add(UpdateFeeRequestModel(
                                                    pApplicationNo: widget
                                                        .updateTncRequestModel
                                                        .pApplicationNo,
                                                    pFeeAmount: data[i]
                                                        .feeAmount!
                                                        .toInt(),
                                                    pFeePaymentType:
                                                        data[i].feePaymentType,
                                                    pId: data[i].id));
                                                if (i == data.length - 1) {
                                                  setState(() {
                                                    updateTncRequestModel
                                                            .pApplicationNo =
                                                        widget
                                                            .updateTncRequestModel
                                                            .pApplicationNo;
                                                    updateTncRequestModel
                                                            .pInsurancePackageCode =
                                                        state
                                                            .tncDataDetailResponseModel
                                                            .data![0]
                                                            .insurancePackageCode!;
                                                    updateTncRequestModel
                                                            .pPaymentType =
                                                        state
                                                            .tncDataDetailResponseModel
                                                            .data![0]
                                                            .firstPaymentTypeDesc!;

                                                    updateTncRequestModel
                                                            .pTenor =
                                                        state
                                                            .tncDataDetailResponseModel
                                                            .data![0]
                                                            .tenor;
                                                  });
                                                  updateFeeBloc.add(
                                                      UpdateFeeAttempt(
                                                          updateFee));
                                                }
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.44,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: thirdColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Center(
                                                child: Text('NEXT',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600))),
                                          ),
                                        ))
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
