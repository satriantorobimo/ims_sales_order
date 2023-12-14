import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_display_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_input_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/detail_info_widget.dart';
import 'package:sales_order/features/client_list/data/client_matching_mode.dart';
import 'package:sales_order/features/home/domain/repo/home_repo.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/drop_down_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../home/data/app_list_response_model.dart';
import '../../../../home/presentation/bloc/app_list_bloc/bloc.dart';

class ApplicationListTabScreen extends StatefulWidget {
  const ApplicationListTabScreen({super.key});

  @override
  State<ApplicationListTabScreen> createState() =>
      _ApplicationListTabScreenState();
}

class _ApplicationListTabScreenState extends State<ApplicationListTabScreen> {
  AppListBloc appListBloc = AppListBloc(homeRepo: HomeRepo());

  var selectedPageNumber = 0;
  var pagination = 0;
  var selectedClientType = 0;
  late List<Data> data = [];
  late List<CustDropdownMenuItem> clientType = [];

  @override
  void initState() {
    getMenu();
    appListBloc.add(const AppListAttempt());
    super.initState();
  }

  Future<void> _showAlertDialogDetail(Data data) async {
    String date;
    if (data.applicationDate != null) {
      DateTime tempDate = DateFormat('yyyy-MM-dd').parse(data.applicationDate!);
      var inputDate = DateTime.parse(tempDate.toString());
      var outputFormat = DateFormat('dd/MM/yyyy');
      date = outputFormat.format(inputDate);
    } else {
      date = '';
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Detail',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 24,
                ),
              )
            ],
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DetailInfoWidget(
                            title: 'Application No',
                            content: data.applicationNo!,
                            type: false),
                        DetailInfoWidget(
                            title: 'Branch',
                            content: data.branchName!,
                            type: false),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DetailInfoWidget(
                            title: 'Application Date',
                            content: date,
                            type: false),
                        DetailInfoWidget(
                            title: 'Facility Name',
                            content: data.facilityDesc ?? '',
                            type: true),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DetailInfoWidget(
                            title: 'Purpose',
                            content: data.purposeLoanName ?? '-',
                            type: false),
                        DetailInfoWidget(
                            title: 'Agreement No',
                            content: data.agreementNo ?? '-',
                            type: false),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const DetailInfoWidget(
                        title: 'Status', content: 'HOLD ENTRY', type: false),
                  ],
                ),
              )),
          actionsPadding: const EdgeInsets.only(bottom: 24.0),
          actions: <Widget>[
            Center(
              child: InkWell(
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
                      child: Text('VIEW',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600))),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _showAlertDialogClient() async {
    final TextEditingController ctrlMotherMaiden = TextEditingController();
    final TextEditingController ctrlKtpNo = TextEditingController();
    final TextEditingController ctrlFullName = TextEditingController();
    final TextEditingController ctrlPob = TextEditingController();
    final TextEditingController ctrlNpwp = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Client Matching',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 24,
                  ),
                )
              ],
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24.0))),
            content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.55,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 290,
                              height: 90,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Client Type',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 290,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.1)),
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
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    child: CustDropDown(
                                      items: clientType,
                                      hintText: "Select Type",
                                      borderRadius: 5,
                                      defaultSelectedIndex: 0,
                                      onChanged: (val) {
                                        setStates(() {
                                          selectedClientType = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            selectedClientType == 0
                                ? const ClientDisplayWidget(
                                    title: 'Document Type', content: 'KTP')
                                : const ClientDisplayWidget(
                                    title: 'Document Type', content: 'NPWP'),
                          ],
                        ),
                        selectedClientType == 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClientInputWidget(
                                          title: 'Mother Maiden Name',
                                          content: '',
                                          ctrl: ctrlMotherMaiden),
                                      ClientInputWidget(
                                        title: 'KTP No',
                                        content: '',
                                        ctrl: ctrlKtpNo,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClientInputWidget(
                                        title: 'Full Name',
                                        content: '',
                                        ctrl: ctrlFullName,
                                      ),
                                      ClientInputWidget(
                                        title: 'Place of Birth',
                                        content: '',
                                        ctrl: ctrlPob,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const ClientDisplayWidget(
                                      title: 'Date of Birth', content: ''),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const ClientDisplayWidget(
                                          title: 'Established Date',
                                          content: ''),
                                      ClientInputWidget(
                                        title: 'NPWP No',
                                        content: '',
                                        ctrl: ctrlNpwp,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ClientInputWidget(
                                    title: 'Full Name',
                                    content: '',
                                    ctrl: ctrlFullName,
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                )),
            actionsPadding: const EdgeInsets.only(bottom: 24.0),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, StringRouterUtil.clientListScreenTabRoute,
                          arguments: ClientMathcingModel(
                              pDocumentType:
                                  clientType[selectedClientType].value == 0
                                      ? 'KTP'
                                      : 'NPWP',
                              pDateOfBirth: '',
                              pDocumentNo:
                                  clientType[selectedClientType].value == 'NPWP'
                                      ? ctrlNpwp.text
                                      : ctrlKtpNo.text,
                              pEstDate: '',
                              pFullName: ctrlFullName.text,
                              pMotherMaidenName: ctrlMotherMaiden.text,
                              pPlaceOfBirth: ctrlPob.text));
                    },
                    child: Container(
                      width: 200,
                      height: 45,
                      decoration: BoxDecoration(
                        color: thirdColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Text('VIEW',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                          child: Text('RESET',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))),
                    ),
                  )
                ],
              )
            ],
          );
        });
      },
    );
  }

  Future<void> getMenu() async {
    setState(() {
      clientType
          .add(const CustDropdownMenuItem(value: 0, child: Text("PERSONAL")));
      clientType
          .add(const CustDropdownMenuItem(value: 1, child: Text("CORPORATE")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Application List',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: InkWell(
                onTap: () {
                  _showAlertDialogClient();
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(28.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  elevation: 6,
                  shadowColor: Colors.grey.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                          width: 1.0, color: Color(0xFFEAEAEA))),
                  child: SizedBox(
                    width: 350,
                    height: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'search record',
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
                const SizedBox(height: 24),
                BlocListener(
                    bloc: appListBloc,
                    listener: (_, AppListState state) {
                      if (state is AppListLoading) {}
                      if (state is AppListLoaded) {
                        log('${state.appListResponseModel.data!.length}');
                        log('${state.appListResponseModel.data!.length / 12}');
                        setState(() {
                          pagination =
                              (state.appListResponseModel.data!.length / 12)
                                  .floor();
                        });
                      }
                      if (state is AppListError) {}
                      if (state is AppListException) {}
                    },
                    child: BlocBuilder(
                        bloc: appListBloc,
                        builder: (_, AppListState state) {
                          if (state is AppListLoading) {
                            return SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 24,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 2 / 1,
                                  padding: const EdgeInsets.all(8.0),
                                  children: List.generate(12, (int index) {
                                    return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          border: Border.all(
                                              color: Colors.grey
                                                  .withOpacity(0.05)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, right: 16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  Text(
                                                    '',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors
                                                            .grey.shade300),
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
                          if (state is AppListLoaded) {
                            return SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Center(
                                child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 24,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 2 / 1,
                                  padding: const EdgeInsets.all(8.0),
                                  children: List.generate(
                                      state.appListResponseModel.data!.length >
                                              12
                                          ? 12
                                          : state.appListResponseModel.data!
                                              .length, (int index) {
                                    String date;
                                    if (state.appListResponseModel.data![index]
                                            .applicationDate !=
                                        null) {
                                      DateTime tempDate =
                                          DateFormat('yyyy-MM-dd').parse(state
                                              .appListResponseModel
                                              .data![index]
                                              .applicationDate!);
                                      var inputDate =
                                          DateTime.parse(tempDate.toString());
                                      var outputFormat =
                                          DateFormat('dd/MM/yyyy');
                                      date = outputFormat.format(inputDate);
                                    } else {
                                      date = '';
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        _showAlertDialogDetail(state
                                            .appListResponseModel.data![index]);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.05)),
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
                                                                  .appListResponseModel
                                                                  .data![index]
                                                                  .applicationStatus!
                                                                  .toUpperCase() ==
                                                              'ON PROCESS'
                                                          ? thirdColor
                                                          : state
                                                                      .appListResponseModel
                                                                      .data![
                                                                          index]
                                                                      .applicationStatus ==
                                                                  'APPROVE'
                                                              ? primaryColor
                                                              : state
                                                                          .appListResponseModel
                                                                          .data![
                                                                              index]
                                                                          .applicationStatus ==
                                                                      'CANCEL'
                                                                  ? const Color(
                                                                      0xFFFFEC3F)
                                                                  : state.appListResponseModel.data![index].applicationStatus ==
                                                                          'HOLD'
                                                                      ? secondaryColor
                                                                      : const Color(
                                                                          0xFFDF0000),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(
                                                                18.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                8.0),
                                                      )),
                                                  child: Center(
                                                    child: Text(
                                                      state
                                                          .appListResponseModel
                                                          .data![index]
                                                          .applicationStatus!,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: state
                                                                          .appListResponseModel
                                                                          .data![
                                                                              index]
                                                                          .applicationStatus ==
                                                                      'ON PROCESS' ||
                                                                  state
                                                                          .appListResponseModel
                                                                          .data![
                                                                              index]
                                                                          .applicationStatus ==
                                                                      'CENCEL' ||
                                                                  state
                                                                          .appListResponseModel
                                                                          .data![
                                                                              index]
                                                                          .applicationStatus ==
                                                                      'HOLD'
                                                              ? Colors.black
                                                              : Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0, right: 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      state
                                                          .appListResponseModel
                                                          .data![index]
                                                          .clientName!,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      state
                                                          .appListResponseModel
                                                          .data![index]
                                                          .applicationNo!,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      'Rp. ${state.appListResponseModel.data![index].financingAmount}',
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .date_range_rounded,
                                                              color: Color(
                                                                  0xFF643FDB),
                                                              size: 16,
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(
                                                              date,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Color(
                                                                      0xFF643FDB)),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 30,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  secondaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          child: Center(
                                                            child: Text(
                                                              state
                                                                      .appListResponseModel
                                                                      .data![
                                                                          index]
                                                                      .facilityDesc ??
                                                                  '-',
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
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
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                mainAxisSpacing: 24,
                                crossAxisSpacing: 16,
                                childAspectRatio: 2 / 1,
                                padding: const EdgeInsets.all(8.0),
                                children: List.generate(12, (int index) {
                                  return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, right: 16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                                Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.grey.shade300),
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
                        })),
                const SizedBox(height: 16),
                SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      selectedPageNumber == 0
                          ? const Icon(
                              Icons.keyboard_arrow_left_rounded,
                              size: 32,
                              color: Colors.grey,
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  selectedPageNumber--;
                                });
                              },
                              child: const Icon(
                                  Icons.keyboard_arrow_left_rounded,
                                  size: 32)),
                      ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: pagination > 10 ? 10 : pagination,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 4);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedPageNumber = index;
                                });
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: selectedPageNumber == index
                                        ? primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: selectedPageNumber == index
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            );
                          }),
                      selectedPageNumber == pagination - 1
                          ? const Icon(
                              Icons.keyboard_arrow_right_rounded,
                              size: 32,
                              color: Colors.grey,
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  selectedPageNumber++;
                                });
                              },
                              child: const Icon(
                                Icons.keyboard_arrow_right_rounded,
                                size: 32,
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
