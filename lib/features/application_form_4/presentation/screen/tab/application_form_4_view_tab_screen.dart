import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_4/domain/repo/form_4_repo.dart';
import 'package:sales_order/features/application_form_4/presentation/bloc/asset_data_detail_bloc/bloc.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class ApplicationForm4ViewTabScreen extends StatefulWidget {
  const ApplicationForm4ViewTabScreen({super.key, required this.applicationNo});
  final String applicationNo;

  @override
  State<ApplicationForm4ViewTabScreen> createState() =>
      _ApplicationForm4ViewTabScreenState();
}

class _ApplicationForm4ViewTabScreenState
    extends State<ApplicationForm4ViewTabScreen> {
  String condition = 'New';
  bool isPresent = false;
  bool checkValid = false;
  int selectIndexMerk = 1000000;
  String selectMerk = '';
  String selectMerkCode = '';
  int selectIndexModel = 1000000;
  String selectModel = '';
  String selectModelCode = '';
  int selectIndexType = 1000000;
  String selectType = '';
  String selectTypeCode = '';

  AssetDataDetailBloc assetDataDetailBloc =
      AssetDataDetailBloc(form4repo: Form4Repo());

  TextEditingController ctrlAmount = TextEditingController();
  TextEditingController ctrlColor = TextEditingController();
  TextEditingController ctrlYear = TextEditingController();
  TextEditingController ctrlChasisNo = TextEditingController();
  TextEditingController ctrlEngineNo = TextEditingController();
  TextEditingController ctrlPlatNo1 = TextEditingController();
  TextEditingController ctrlPlatNo2 = TextEditingController();
  TextEditingController ctrlPlatNo3 = TextEditingController();
  TextEditingController ctrlStatus = TextEditingController();

  @override
  void initState() {
    assetDataDetailBloc.add(AssetDataDetailAttempt(widget.applicationNo));
    super.initState();
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
                                      '4',
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
                                color: const Color(0xFFDCDCDC),
                              ),
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
                                color: Color(0xFFDCDCDC),
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
                    padding: const EdgeInsets.only(
                        left: 22.0, right: 20.0, top: 8.0),
                    child: BlocListener(
                        bloc: assetDataDetailBloc,
                        listener: (_, AssetDataDetailState state) {
                          if (state is AssetDataDetailLoading) {}
                          if (state is AssetDataDetailLoaded) {
                            setState(() {
                              if (state.assetDetailResponseModel.data![0]
                                      .vehicleMerkCode !=
                                  null) {
                                selectMerkCode = state.assetDetailResponseModel
                                    .data![0].vehicleMerkCode!;
                                selectMerk = state.assetDetailResponseModel
                                    .data![0].vehicleMerkDesc!;
                              }
                              if (state.assetDetailResponseModel.data![0]
                                      .vehicleModelCode !=
                                  null) {
                                selectModelCode = state.assetDetailResponseModel
                                    .data![0].vehicleModelCode!;
                                selectModel = state.assetDetailResponseModel
                                    .data![0].vehicleModelDesc!;
                              }
                              if (state.assetDetailResponseModel.data![0]
                                      .vehicleTypeCode !=
                                  null) {
                                selectTypeCode = state.assetDetailResponseModel
                                    .data![0].vehicleTypeCode!;
                                selectType = state.assetDetailResponseModel
                                    .data![0].vehicleTypeDesc!;
                              }
                              if (state.assetDetailResponseModel.data![0]
                                      .assetCondition !=
                                  null) {
                                condition = state.assetDetailResponseModel
                                            .data![0].assetCondition! ==
                                        'NEW'
                                    ? 'New'
                                    : 'Used';
                              }

                              if (state.assetDetailResponseModel.data![0]
                                      .assetAmount !=
                                  null) {
                                ctrlAmount.text = state.assetDetailResponseModel
                                    .data![0].assetAmount!
                                    .toString();
                              }
                              if (state.assetDetailResponseModel.data![0]
                                      .colour !=
                                  null) {
                                ctrlColor.text = state
                                    .assetDetailResponseModel.data![0].colour!;
                              }
                              if (state.assetDetailResponseModel.data![0]
                                          .assetYear !=
                                      null ||
                                  state.assetDetailResponseModel.data![0]
                                          .assetYear !=
                                      "") {
                                ctrlYear.text = state.assetDetailResponseModel
                                    .data![0].assetYear!;
                              }
                              if (state.assetDetailResponseModel.data![0]
                                      .chassisNo !=
                                  null) {
                                ctrlChasisNo.text = state
                                    .assetDetailResponseModel
                                    .data![0]
                                    .chassisNo!;
                              }
                              if (state.assetDetailResponseModel.data![0]
                                      .engineNo !=
                                  null) {
                                ctrlEngineNo.text = state
                                    .assetDetailResponseModel
                                    .data![0]
                                    .engineNo!;
                              }
                              if (state.assetDetailResponseModel.data![0]
                                      .platNo1 !=
                                  null) {
                                ctrlPlatNo1.text = state
                                    .assetDetailResponseModel.data![0].platNo1!;
                                ctrlPlatNo2.text = state
                                    .assetDetailResponseModel.data![0].platNo2!;
                                ctrlPlatNo3.text = state
                                    .assetDetailResponseModel.data![0].platNo3!;
                              }
                            });
                          }
                          if (state is AssetDataDetailError) {}
                          if (state is AssetDataDetailException) {}
                        },
                        child: BlocBuilder(
                            bloc: assetDataDetailBloc,
                            builder: (_, AssetDataDetailState state) {
                              if (state is AssetDataDetailLoading) {
                                return _loading();
                              }
                              if (state is AssetDataDetailLoaded) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      '1. Merk',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' *',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Stack(
                                                  alignment:
                                                      const Alignment(0, 0),
                                                  children: [
                                                    Container(
                                                      width: 280,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1)),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16.0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          selectMerk == ''
                                                              ? 'Select Merk'
                                                              : selectMerk,
                                                          style: TextStyle(
                                                              color: selectMerk ==
                                                                      ''
                                                                  ? Colors.grey
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    ),
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
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      '2. Model',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' *',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Stack(
                                                  alignment:
                                                      const Alignment(0, 0),
                                                  children: [
                                                    Container(
                                                      width: 280,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1)),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16.0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          selectModel == ''
                                                              ? 'Select Model'
                                                              : selectModel,
                                                          style: TextStyle(
                                                              color: selectModel ==
                                                                      ''
                                                                  ? Colors.grey
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    ),
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
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      '3. Type',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' *',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Stack(
                                                  alignment:
                                                      const Alignment(0, 0),
                                                  children: [
                                                    Container(
                                                      width: 280,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1)),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16.0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          selectType == ''
                                                              ? 'Type'
                                                              : selectType,
                                                          style: TextStyle(
                                                              color: selectType ==
                                                                      ''
                                                                  ? Colors.grey
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    ),
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
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      'Asset Amount',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' *',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Material(
                                                  elevation: 6,
                                                  shadowColor: Colors.grey
                                                      .withOpacity(0.4),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      side: const BorderSide(
                                                          width: 1.0,
                                                          color: Color(
                                                              0xFFEAEAEA))),
                                                  child: SizedBox(
                                                    width: 280,
                                                    height: 50,
                                                    child: TextFormField(
                                                      controller: ctrlAmount,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Asset Amount',
                                                              isDense: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      16.0,
                                                                      20.0,
                                                                      20.0,
                                                                      16.0),
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5)),
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      '4. Condition',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' *',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                SizedBox(
                                                  height: 52,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Container(
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: condition ==
                                                                    'New'
                                                                ? primaryColor
                                                                : const Color(
                                                                    0xFFE1E1E1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: const Center(
                                                              child: Text('New',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600))),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Container(
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: condition ==
                                                                    'Used'
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
                                                                  'Used',
                                                                  style: TextStyle(
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
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      '5. Colour',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' *',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Material(
                                                  elevation: 6,
                                                  shadowColor: Colors.grey
                                                      .withOpacity(0.4),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      side: const BorderSide(
                                                          width: 1.0,
                                                          color: Color(
                                                              0xFFEAEAEA))),
                                                  child: SizedBox(
                                                    width: 280,
                                                    height: 50,
                                                    child: TextFormField(
                                                      controller: ctrlColor,
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Colour',
                                                              isDense: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      16.0,
                                                                      20.0,
                                                                      20.0,
                                                                      16.0),
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5)),
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      '6. Asset Year',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' *',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Material(
                                                  elevation: 6,
                                                  shadowColor: Colors.grey
                                                      .withOpacity(0.4),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      side: const BorderSide(
                                                          width: 1.0,
                                                          color: Color(
                                                              0xFFEAEAEA))),
                                                  child: SizedBox(
                                                    width: 190,
                                                    height: 50,
                                                    child: TextFormField(
                                                      controller: ctrlYear,
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Asset Year',
                                                              isDense: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      16.0,
                                                                      20.0,
                                                                      20.0,
                                                                      16.0),
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5)),
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      '7. Chasis No',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' *',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Material(
                                                  elevation: 6,
                                                  shadowColor: Colors.grey
                                                      .withOpacity(0.4),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      side: const BorderSide(
                                                          width: 1.0,
                                                          color: Color(
                                                              0xFFEAEAEA))),
                                                  child: SizedBox(
                                                    width: 280,
                                                    height: 50,
                                                    child: TextFormField(
                                                      controller: ctrlChasisNo,
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Chasis No',
                                                              isDense: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      16.0,
                                                                      20.0,
                                                                      20.0,
                                                                      16.0),
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5)),
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      '8. Engine No',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' *',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Material(
                                                  elevation: 6,
                                                  shadowColor: Colors.grey
                                                      .withOpacity(0.4),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      side: const BorderSide(
                                                          width: 1.0,
                                                          color: Color(
                                                              0xFFEAEAEA))),
                                                  child: SizedBox(
                                                    width: 280,
                                                    height: 50,
                                                    child: TextFormField(
                                                      controller: ctrlEngineNo,
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Engine No',
                                                              isDense: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      16.0,
                                                                      20.0,
                                                                      20.0,
                                                                      16.0),
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5)),
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      '9. Plat no',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' *',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                SizedBox(
                                                  width: 280,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Material(
                                                        elevation: 6,
                                                        shadowColor: Colors.grey
                                                            .withOpacity(0.4),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            side: const BorderSide(
                                                                width: 1.0,
                                                                color: Color(
                                                                    0xFFEAEAEA))),
                                                        child: SizedBox(
                                                          width: 62,
                                                          height: 50,
                                                          child: TextFormField(
                                                            controller:
                                                                ctrlPlatNo1,
                                                            readOnly: true,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        'B',
                                                                    isDense:
                                                                        true,
                                                                    contentPadding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            16.0,
                                                                            20.0,
                                                                            20.0,
                                                                            16.0),
                                                                    hintStyle: TextStyle(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.5)),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none,
                                                                    )),
                                                          ),
                                                        ),
                                                      ),
                                                      Material(
                                                        elevation: 6,
                                                        shadowColor: Colors.grey
                                                            .withOpacity(0.4),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            side: const BorderSide(
                                                                width: 1.0,
                                                                color: Color(
                                                                    0xFFEAEAEA))),
                                                        child: SizedBox(
                                                          width: 120,
                                                          height: 50,
                                                          child: TextFormField(
                                                            controller:
                                                                ctrlPlatNo2,
                                                            readOnly: true,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        '1234',
                                                                    isDense:
                                                                        true,
                                                                    contentPadding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            16.0,
                                                                            20.0,
                                                                            20.0,
                                                                            16.0),
                                                                    hintStyle: TextStyle(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.5)),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none,
                                                                    )),
                                                          ),
                                                        ),
                                                      ),
                                                      Material(
                                                        elevation: 6,
                                                        shadowColor: Colors.grey
                                                            .withOpacity(0.4),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            side: const BorderSide(
                                                                width: 1.0,
                                                                color: Color(
                                                                    0xFFEAEAEA))),
                                                        child: SizedBox(
                                                          width: 68,
                                                          height: 50,
                                                          child: TextFormField(
                                                            controller:
                                                                ctrlPlatNo3,
                                                            readOnly: true,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        'XXX',
                                                                    isDense:
                                                                        true,
                                                                    contentPadding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            16.0,
                                                                            20.0,
                                                                            20.0,
                                                                            8.0),
                                                                    hintStyle: TextStyle(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.5)),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none,
                                                                    )),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                );
                              }
                              return _loading();
                            }))),
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
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context,
                            StringRouterUtil.applicationForm5ViewScreenTabRoute,
                            arguments: widget.applicationNo);
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _loading() {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 32,
          crossAxisSpacing: 16,
          childAspectRatio: 1 / 0.25,
          padding: const EdgeInsets.all(8.0),
          children: List.generate(20, (int index) {
            return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.05)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(-6, 4), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade300),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.shade300),
                          ),
                          Text(
                            '',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade300),
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
}
