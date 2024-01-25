import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/cancel_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/empty_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_5/data/application_fee_detail_model.dart'
    as fee;
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

class ApplicationForm5TabScreen extends StatefulWidget {
  const ApplicationForm5TabScreen(
      {super.key, required this.updateTncRequestModel});
  final UpdateTncRequestModel updateTncRequestModel;

  @override
  State<ApplicationForm5TabScreen> createState() =>
      _ApplicationForm5TabScreenState();
}

class _ApplicationForm5TabScreenState extends State<ApplicationForm5TabScreen> {
  String condition = 'ARREAR';
  List<String> feeType = ['FULL PAID', 'CAPITALIZE', 'REDUCE'];
  List<fee.Data> data = [];
  bool isLoading = false;
  int selectIndexInsurance = 10000;
  String selectInsurance = '';
  String selectInsuranceCode = '';
  int tenor = 0;
  List<UpdateFeeRequestModel> updateFee = [];

  InsuranceBloc insuranceBloc = InsuranceBloc(form5repo: Form5Repo());
  FeeDataBloc feeDataBloc = FeeDataBloc(form5repo: Form5Repo());
  TncDataBloc tncDataBloc = TncDataBloc(form5repo: Form5Repo());
  UpdateTncBloc updateTncBloc = UpdateTncBloc(form5repo: Form5Repo());
  UpdateFeeBloc updateFeeBloc = UpdateFeeBloc(form5repo: Form5Repo());

  @override
  void initState() {
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
                      padding: EdgeInsets.only(top: 32.0, left: 24, right: 24),
                      child: Text(
                        'Insurance',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
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
                              left: 24, right: 24, bottom: 24),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text(
            'Application Form',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 24, top: 16, bottom: 8),
                child: InkWell(
                  onTap: () {
                    OptionWidget(isUsed: true).showBottomOption(
                        context, widget.updateTncRequestModel.pApplicationNo!);
                  },
                  child: const Icon(
                    Icons.more_vert_rounded,
                    size: 28,
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 3,
                                color: Colors.white,
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Center(
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: primaryColor,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Client',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 3,
                                color: primaryColor,
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Center(
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: primaryColor,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Loan Data',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 3,
                                color: primaryColor,
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Center(
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: primaryColor,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Asset',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 3,
                                color: primaryColor,
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFFFD174),
                                        width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Center(
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFFD174)),
                                    child: const Icon(
                                      Icons.warning_amber_rounded,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: const Color(0xFFFFD174),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'T&C',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 3,
                                color: const Color(0xFFDCDCDC),
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFDCDCDC)),
                                  child: const Center(
                                    child: Text(
                                      '5',
                                      style: TextStyle(
                                          color: Color(0xFF444444),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Document',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.72,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 22.0, right: 20.0, top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocListener(
                          bloc: tncDataBloc,
                          listener: (_, TncDataState state) {
                            if (state is TncDataLoading) {}
                            if (state is TncDataLoaded) {
                              condition = state.tncDataDetailResponseModel
                                  .data![0].firstPaymentTypeDesc!;
                              tenor = state
                                  .tncDataDetailResponseModel.data![0].tenor!;
                              if (state.tncDataDetailResponseModel.data![0]
                                      .insurancePackageCode !=
                                  null) {
                                selectInsuranceCode = state
                                    .tncDataDetailResponseModel
                                    .data![0]
                                    .insurancePackageCode!;
                                selectInsurance = state
                                    .tncDataDetailResponseModel
                                    .data![0]
                                    .insurancePackageDesc!;
                              }
                            }
                            if (state is TncDataError) {}
                            if (state is TncDataException) {}
                          },
                          child: BlocBuilder(
                              bloc: tncDataBloc,
                              builder: (_, TncDataState state) {
                                if (state is TncDataLoading) {
                                  return Container();
                                }
                                if (state is TncDataLoaded) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.23,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Payment Type',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  SizedBox(
                                                    height: 52,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              condition =
                                                                  'ARREAR';
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: condition ==
                                                                      'ARREAR'
                                                                  ? primaryColor
                                                                  : const Color(
                                                                      0xFFE1E1E1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: const Center(
                                                                child: Text(
                                                                    'ARREAR',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w600))),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              condition =
                                                                  'ADVANCE';
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: condition ==
                                                                      'ADVANCE'
                                                                  ? primaryColor
                                                                  : const Color(
                                                                      0xFFE1E1E1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: const Center(
                                                                child: Text(
                                                                    'ADVANCE',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w600))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Flat Rate (p.a)',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    width: 280,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.1)),
                                                      color: const Color(
                                                          0xFFFAF9F9),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          blurRadius: 6,
                                                          offset: const Offset(
                                                              -6,
                                                              4), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        '${state.tncDataDetailResponseModel.data![0].interestFlatRate}',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF6E6E6E),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.23,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'DP (%)',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    width: 280,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.1)),
                                                      color: const Color(
                                                          0xFFFAF9F9),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          blurRadius: 6,
                                                          offset: const Offset(
                                                              -6,
                                                              4), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        '${state.tncDataDetailResponseModel.data![0].dpPct}',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF6E6E6E),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'DP Amount',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    width: 280,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.1)),
                                                      color: const Color(
                                                          0xFFFAF9F9),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          blurRadius: 6,
                                                          offset: const Offset(
                                                              -6,
                                                              4), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        GeneralUtil.convertToIdr(
                                                            state
                                                                .tncDataDetailResponseModel
                                                                .data![0]
                                                                .dpAmount,
                                                            2),
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF6E6E6E),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.23,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Installment Amount',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    width: 280,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.1)),
                                                      color: const Color(
                                                          0xFFFAF9F9),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          blurRadius: 6,
                                                          offset: const Offset(
                                                              -6,
                                                              4), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        GeneralUtil.convertToIdr(
                                                            state
                                                                .tncDataDetailResponseModel
                                                                .data![0]
                                                                .installmentAmount,
                                                            2),
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF6E6E6E),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Tenor',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    width: 280,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.1)),
                                                      color: const Color(
                                                          0xFFFAF9F9),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          blurRadius: 6,
                                                          offset: const Offset(
                                                              -6,
                                                              4), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        '${state.tncDataDetailResponseModel.data![0].tenor}',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF6E6E6E),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.23,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text(
                                                        'Insurance Package',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        ' *',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Stack(
                                                    alignment:
                                                        const Alignment(0, 0),
                                                    children: [
                                                      BlocListener(
                                                          bloc: insuranceBloc,
                                                          listener: (_,
                                                              InsuranceState
                                                                  state) {
                                                            if (state
                                                                is InsuranceLoading) {}
                                                            if (state
                                                                is InsuranceLoaded) {}
                                                            if (state
                                                                is InsuranceError) {}
                                                            if (state
                                                                is InsuranceException) {}
                                                          },
                                                          child: BlocBuilder(
                                                              bloc:
                                                                  insuranceBloc,
                                                              builder: (_,
                                                                  InsuranceState
                                                                      state) {
                                                                if (state
                                                                    is InsuranceLoading) {}
                                                                if (state
                                                                    is InsuranceLoaded) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      _showBottomInsurance(
                                                                          state
                                                                              .lookUpInsurancePackageModel);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          280,
                                                                      height:
                                                                          50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.1)),
                                                                        color: Colors
                                                                            .white,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.1),
                                                                            blurRadius:
                                                                                6,
                                                                            offset:
                                                                                const Offset(-6, 4), // Shadow position
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              16.0,
                                                                          right:
                                                                              16.0),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          selectInsurance == ''
                                                                              ? 'Select Insurance'
                                                                              : selectInsurance,
                                                                          style: TextStyle(
                                                                              color: selectInsurance == '' ? Colors.grey.withOpacity(0.5) : Colors.black,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w400),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                return Container(
                                                                  width: 280,
                                                                  height: 50,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.1)),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.1),
                                                                        blurRadius:
                                                                            6,
                                                                        offset: const Offset(
                                                                            -6,
                                                                            4), // Shadow position
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          16.0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      '',
                                                                      style: TextStyle(
                                                                          color: Colors.grey.withOpacity(
                                                                              0.5),
                                                                          fontSize:
                                                                              15,
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
                                                          color:
                                                              Color(0xFF3D3D3D),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ],
                                  );
                                }
                                return Container();
                              })),
                      const Padding(
                          padding: EdgeInsets.only(top: 24.0, bottom: 24.0),
                          child: Divider()),
                      BlocListener(
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
                                if (state is FeeDataLoading) {}
                                if (state is FeeDataLoaded) {
                                  return Expanded(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const SizedBox(width: 16);
                                        },
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.23,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data[index].feeDesc!,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Container(
                                                        width: 280,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1)),
                                                          color: const Color(
                                                              0xFFFAF9F9),
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
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 16.0,
                                                                right: 16.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            GeneralUtil
                                                                .convertToIdr(
                                                                    data[index]
                                                                        .feeAmount,
                                                                    2),
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF6E6E6E),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Payment Type',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: data[index]
                                                                        .isCalculated ==
                                                                    '1'
                                                                ? null
                                                                : () {
                                                                    _showBottomFeeType(
                                                                        index);
                                                                  },
                                                            child: Container(
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.1)),
                                                                color: data[index].isCalculated ==
                                                                        '1'
                                                                    ? const Color(
                                                                        0xFFFAF9F9)
                                                                    : Colors
                                                                        .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.1),
                                                                    blurRadius:
                                                                        6,
                                                                    offset: const Offset(
                                                                        -6,
                                                                        4), // Shadow position
                                                                  ),
                                                                ],
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          16.0),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  data[index]
                                                                      .feePaymentType!,
                                                                  style: TextStyle(
                                                                      color: data[index]
                                                                                  .isCalculated ==
                                                                              '1'
                                                                          ? const Color(
                                                                              0xFF6E6E6E)
                                                                          : Colors
                                                                              .black,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: 16,
                                                            top: 14,
                                                            child: data[index]
                                                                        .isCalculated ==
                                                                    '1'
                                                                ? Container()
                                                                : const Icon(
                                                                    Icons
                                                                        .search_rounded,
                                                                    color: Color(
                                                                        0xFF3D3D3D),
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
                                return Container();
                              })),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 200,
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
                                  for (int i = 0; i < data.length; i++) {
                                    updateFee.add(UpdateFeeRequestModel(
                                        pApplicationNo: widget
                                            .updateTncRequestModel
                                            .pApplicationNo,
                                        pFeeAmount: data[i].feeAmount!.toInt(),
                                        pFeePaymentType: data[i].feePaymentType,
                                        pId: data[i].id));
                                    if (i == data.length - 1) {
                                      updateFeeBloc
                                          .add(UpdateFeeAttempt(updateFee));
                                    }
                                  }
                                }
                                if (state is UpdateTncError) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  GeneralUtil()
                                      .showSnackBar(context, state.error!);
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
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pushNamed(
                                      context,
                                      StringRouterUtil
                                          .applicationForm7ScreenTabRoute,
                                      arguments: widget.updateTncRequestModel
                                          .pApplicationNo);
                                }
                                if (state is UpdateFeeError) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  GeneralUtil()
                                      .showSnackBar(context, state.error!);
                                }
                                if (state is UpdateFeeException) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              })
                        ],
                        child: isLoading
                            ? const SizedBox(
                                width: 200,
                                height: 45,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  if (selectInsurance == '') {
                                    EmptyWidget().showBottomEmpty(context);
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });
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
                                },
                                child: Container(
                                  width: 200,
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
                              ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
