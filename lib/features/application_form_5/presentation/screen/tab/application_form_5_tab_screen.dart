import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_5/data/look_up_insurance_package_model.dart';
import 'package:sales_order/features/application_form_5/data/update_tnc_request_model.dart';
import 'package:sales_order/features/application_form_5/domain/repo/form_5_repo.dart';
import 'package:sales_order/features/application_form_5/presentation/bloc/fee_data_bloc/bloc.dart';
import 'package:sales_order/features/application_form_5/presentation/bloc/insurance_bloc/bloc.dart';
import 'package:sales_order/features/application_form_5/presentation/bloc/tnc_data_bloc/bloc.dart';
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

  int selectIndexInsurance = 10000;
  String selectInsurance = '';
  String selectInsuranceCode = '';
  int tenor = 0;

  InsuranceBloc insuranceBloc = InsuranceBloc(form5repo: Form5Repo());
  FeeDataBloc feeDataBloc = FeeDataBloc(form5repo: Form5Repo());
  TncDataBloc tncDataBloc = TncDataBloc(form5repo: Form5Repo());
  UpdateTncBloc updateTncBloc = UpdateTncBloc(form5repo: Form5Repo());

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
                        decoration: InputDecoration(
                            hintText: 'Search',
                            isDense: true,
                            contentPadding: const EdgeInsets.all(24),
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.5)),
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
                      itemCount: lookUpInsurancePackageModel.data!.length,
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
                                selectInsurance = lookUpInsurancePackageModel
                                    .data![index].packageName!;
                                selectInsuranceCode =
                                    lookUpInsurancePackageModel
                                        .data![index].code!;
                                selectIndexInsurance = index;
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lookUpInsurancePackageModel
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
                                                        '${state.tncDataDetailResponseModel.data![0].dpAmount}',
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
                                                        '${state.tncDataDetailResponseModel.data![0].installmentAmount}',
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
                            if (state is FeeDataLoaded) {}
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
                                        itemCount: state
                                            .applicationFeeDetailModel
                                            .data!
                                            .length,
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
                                                        state
                                                            .applicationFeeDetailModel
                                                            .data![index]
                                                            .feeDesc!,
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
                                                            '${state.applicationFeeDetailModel.data![0].feeAmount}',
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
                                                      SizedBox(
                                                        height: 52,
                                                        child: Container(
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                                  state
                                                                      .applicationFeeDetailModel
                                                                      .data![0]
                                                                      .feePaymentType!,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600))),
                                                        ),
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     SizedBox(
                      //         width: MediaQuery.of(context).size.width * 0.23,
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 const Text(
                      //                   'Biaya Admin',
                      //                   style: TextStyle(
                      //                       color: Colors.black,
                      //                       fontSize: 18,
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //                 const SizedBox(height: 8),
                      //                 Material(
                      //                   elevation: 6,
                      //                   shadowColor:
                      //                       Colors.grey.withOpacity(0.4),
                      //                   shape: RoundedRectangleBorder(
                      //                       borderRadius:
                      //                           BorderRadius.circular(10),
                      //                       side: const BorderSide(
                      //                           width: 1.0,
                      //                           color: Color(0xFFEAEAEA))),
                      //                   child: SizedBox(
                      //                     width: 280,
                      //                     height: 50,
                      //                     child: TextFormField(
                      //                       keyboardType: TextInputType.text,
                      //                       decoration: InputDecoration(
                      //                           hintText: 'Biaya Admin',
                      //                           isDense: true,
                      //                           contentPadding:
                      //                               const EdgeInsets.fromLTRB(
                      //                                   16.0, 20.0, 20.0, 16.0),
                      //                           hintStyle: TextStyle(
                      //                               color: Colors.grey
                      //                                   .withOpacity(0.5)),
                      //                           filled: true,
                      //                           fillColor: Colors.white,
                      //                           border: OutlineInputBorder(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(10),
                      //                             borderSide: BorderSide.none,
                      //                           )),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const SizedBox(height: 20),
                      //             Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 const Text(
                      //                   'Payment Type',
                      //                   style: TextStyle(
                      //                       color: Colors.black,
                      //                       fontSize: 18,
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //                 const SizedBox(height: 8),
                      //                 SizedBox(
                      //                   height: 52,
                      //                   child: Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.start,
                      //                     children: [
                      //                       InkWell(
                      //                         onTap: () {
                      //                           setState(() {
                      //                             condition = 'Arrear';
                      //                           });
                      //                         },
                      //                         child: Container(
                      //                           height: 40,
                      //                           padding:
                      //                               const EdgeInsets.all(8.0),
                      //                           decoration: BoxDecoration(
                      //                             color: condition == 'Arrear'
                      //                                 ? primaryColor
                      //                                 : const Color(0xFFE1E1E1),
                      //                             borderRadius:
                      //                                 BorderRadius.circular(10),
                      //                           ),
                      //                           child: const Center(
                      //                               child: Text('FULL PAID',
                      //                                   style: TextStyle(
                      //                                       fontSize: 15,
                      //                                       color: Colors.white,
                      //                                       fontWeight:
                      //                                           FontWeight
                      //                                               .w600))),
                      //                         ),
                      //                       ),
                      //                       const SizedBox(width: 8),
                      //                       InkWell(
                      //                         onTap: () {
                      //                           setState(() {
                      //                             condition = 'Advance';
                      //                           });
                      //                         },
                      //                         child: Container(
                      //                           height: 40,
                      //                           padding:
                      //                               const EdgeInsets.all(8.0),
                      //                           decoration: BoxDecoration(
                      //                             color: condition == 'Advance'
                      //                                 ? primaryColor
                      //                                 : const Color(0xFFE1E1E1),
                      //                             borderRadius:
                      //                                 BorderRadius.circular(10),
                      //                           ),
                      //                           child: const Center(
                      //                               child: Text('CAPITAL PAID',
                      //                                   style: TextStyle(
                      //                                       fontSize: 15,
                      //                                       color: Colors.white,
                      //                                       fontWeight:
                      //                                           FontWeight
                      //                                               .w600))),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         )),
                      //     SizedBox(
                      //         width: MediaQuery.of(context).size.width * 0.23,
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 const Text(
                      //                   'Biaya Provisi',
                      //                   style: TextStyle(
                      //                       color: Colors.black,
                      //                       fontSize: 18,
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //                 const SizedBox(height: 8),
                      //                 Material(
                      //                   elevation: 6,
                      //                   shadowColor:
                      //                       Colors.grey.withOpacity(0.4),
                      //                   shape: RoundedRectangleBorder(
                      //                       borderRadius:
                      //                           BorderRadius.circular(10),
                      //                       side: const BorderSide(
                      //                           width: 1.0,
                      //                           color: Color(0xFFEAEAEA))),
                      //                   child: SizedBox(
                      //                     width: 280,
                      //                     height: 50,
                      //                     child: TextFormField(
                      //                       keyboardType: TextInputType.text,
                      //                       decoration: InputDecoration(
                      //                           hintText: 'Biaya Provisi',
                      //                           isDense: true,
                      //                           contentPadding:
                      //                               const EdgeInsets.fromLTRB(
                      //                                   16.0, 20.0, 20.0, 16.0),
                      //                           hintStyle: TextStyle(
                      //                               color: Colors.grey
                      //                                   .withOpacity(0.5)),
                      //                           filled: true,
                      //                           fillColor: Colors.white,
                      //                           border: OutlineInputBorder(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(10),
                      //                             borderSide: BorderSide.none,
                      //                           )),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const SizedBox(height: 20),
                      //             Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 const Text(
                      //                   'Payment Type',
                      //                   style: TextStyle(
                      //                       color: Colors.black,
                      //                       fontSize: 18,
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //                 const SizedBox(height: 8),
                      //                 SizedBox(
                      //                   height: 52,
                      //                   child: Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.start,
                      //                     children: [
                      //                       InkWell(
                      //                         onTap: () {
                      //                           setState(() {
                      //                             condition2 = 'Arrear';
                      //                           });
                      //                         },
                      //                         child: Container(
                      //                           height: 40,
                      //                           padding:
                      //                               const EdgeInsets.all(8.0),
                      //                           decoration: BoxDecoration(
                      //                             color: condition2 == 'Arrear'
                      //                                 ? primaryColor
                      //                                 : const Color(0xFFE1E1E1),
                      //                             borderRadius:
                      //                                 BorderRadius.circular(10),
                      //                           ),
                      //                           child: const Center(
                      //                               child: Text('FULL PAID',
                      //                                   style: TextStyle(
                      //                                       fontSize: 15,
                      //                                       color: Colors.white,
                      //                                       fontWeight:
                      //                                           FontWeight
                      //                                               .w600))),
                      //                         ),
                      //                       ),
                      //                       const SizedBox(width: 8),
                      //                       InkWell(
                      //                         onTap: () {
                      //                           setState(() {
                      //                             condition2 = 'Advance';
                      //                           });
                      //                         },
                      //                         child: Container(
                      //                           height: 40,
                      //                           padding:
                      //                               const EdgeInsets.all(8.0),
                      //                           decoration: BoxDecoration(
                      //                             color: condition2 == 'Advance'
                      //                                 ? primaryColor
                      //                                 : const Color(0xFFE1E1E1),
                      //                             borderRadius:
                      //                                 BorderRadius.circular(10),
                      //                           ),
                      //                           child: const Center(
                      //                               child: Text('CAPITAL PAID',
                      //                                   style: TextStyle(
                      //                                       fontSize: 15,
                      //                                       color: Colors.white,
                      //                                       fontWeight:
                      //                                           FontWeight
                      //                                               .w600))),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         )),
                      //     SizedBox(
                      //       width: MediaQuery.of(context).size.width * 0.23,
                      //     ),
                      //     SizedBox(
                      //       width: MediaQuery.of(context).size.width * 0.23,
                      //     ),
                      //   ],
                      // ),
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
                    BlocListener(
                        bloc: updateTncBloc,
                        listener: (_, UpdateTncState state) {
                          if (state is UpdateTncLoading) {}
                          if (state is UpdateTncLoaded) {
                            Navigator.pushNamed(context,
                                StringRouterUtil.applicationForm7ScreenTabRoute,
                                arguments: widget
                                    .updateTncRequestModel.pApplicationNo);
                          }
                          if (state is UpdateTncError) {
                            GeneralUtil().showSnackBar(context, state.error!);
                          }
                          if (state is UpdateTncException) {}
                        },
                        child: BlocBuilder(
                            bloc: updateTncBloc,
                            builder: (_, UpdateTncState state) {
                              if (state is UpdateTncLoading) {
                                return const SizedBox(
                                  width: 200,
                                  height: 45,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state is UpdateTncLoaded) {
                                return InkWell(
                                  onTap: () {
                                    updateTncBloc.add(UpdateTncAttempt(
                                        UpdateTncRequestModel(
                                            pApplicationNo: widget
                                                .updateTncRequestModel
                                                .pApplicationNo,
                                            pInsurancePackageCode:
                                                selectInsuranceCode,
                                            pPaymentType: condition,
                                            pTenor: tenor)));
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
                                );
                              }
                              return InkWell(
                                onTap: () {
                                  // Navigator.pushNamed(
                                  //     context,
                                  //     StringRouterUtil
                                  //         .applicationForm7ScreenTabRoute,
                                  //     arguments: widget.updateTncRequestModel
                                  //         .pApplicationNo);
                                  updateTncBloc.add(UpdateTncAttempt(
                                      UpdateTncRequestModel(
                                          pApplicationNo: widget
                                              .updateTncRequestModel
                                              .pApplicationNo,
                                          pInsurancePackageCode:
                                              selectInsuranceCode,
                                          pPaymentType: condition,
                                          pTenor: tenor)));
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
                              );
                            })),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
