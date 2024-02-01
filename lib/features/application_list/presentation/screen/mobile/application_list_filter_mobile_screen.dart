import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_display_mobile_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_input_ktp_mobile_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_input_mobile_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_input_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/detail_info_mobile_widget.dart';
import 'package:sales_order/features/client_list/data/client_matching_mode.dart';
import 'package:sales_order/features/home/data/application_model.dart';
import 'package:sales_order/features/home/domain/repo/home_repo.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/database_helper.dart';
import 'package:sales_order/utility/drop_down_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../home/data/app_list_response_model.dart';
import '../../../../home/presentation/bloc/app_list_bloc/bloc.dart';

class ApplicationListFilterMobileScreen extends StatefulWidget {
  const ApplicationListFilterMobileScreen({super.key, required this.status});
  final String status;

  @override
  State<ApplicationListFilterMobileScreen> createState() =>
      _ApplicationListFilterMobileScreenState();
}

class _ApplicationListFilterMobileScreenState
    extends State<ApplicationListFilterMobileScreen> {
  bool isLoading = true;
  List<ApplicationModel> menu = [];

  late List<CustDropdownMenuItem> clientType = [];

  AppListBloc appListBloc = AppListBloc(homeRepo: HomeRepo());

  var selectedClientType = 0;
  late List<Data> data = [];
  late List<Data> dataFilter = [];
  late List<Data> dataFilterSearch = [];
  TextEditingController ctrlDate = TextEditingController();

  @override
  void initState() {
    getData();
    getMenu();
    super.initState();
  }

  getData() async {
    final data = await DatabaseHelper.getUserData();
    appListBloc.add(AppListAttempt(data[0]['uid']));
  }

  Future<void> getMenu() async {
    setState(() {
      clientType
          .add(const CustDropdownMenuItem(value: 0, child: Text("PERSONAL")));
      clientType
          .add(const CustDropdownMenuItem(value: 1, child: Text("CORPORATE")));
    });
  }

  Future<String> _presentDatePicker() async {
    return showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: DateTime.now().add(const Duration(days: -6570)),
            lastDate: DateTime.now().add(const Duration(days: -6570)),
            firstDate: DateTime.now().add(const Duration(days: -15000)))
        .then((pickedDate) {
      if (pickedDate == null) {
        return '';
      } else {
        return DateFormat('yyyy-MM-dd').format(pickedDate).toString();
      }
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      dataFilterSearch = data
          .where((item) =>
              item.clientName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      dataFilter = dataFilterSearch;
    });
  }

  Future<void> _showBottom() {
    final TextEditingController ctrlMotherMaiden = TextEditingController();
    final TextEditingController ctrlKtpNo = TextEditingController();
    final TextEditingController ctrlFullName = TextEditingController();
    final TextEditingController ctrlPob = TextEditingController();
    final TextEditingController ctrlNpwp = TextEditingController();
    String dateSend = '';
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 3),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Client Matching',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Client Type',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                                color: Colors.white,
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
                          ? Column(
                              children: [
                                ClientDisplayMobileWidget(
                                  title: 'Document Type',
                                  content: 'KTP',
                                  onTap: () {},
                                ),
                                ClientInputKtpMobileWidget(
                                  title: 'KTP No',
                                  content: '',
                                  ctrl: ctrlKtpNo,
                                )
                              ],
                            )
                          : Column(
                              children: [
                                ClientDisplayMobileWidget(
                                  title: 'Document Type',
                                  content: 'NPWP',
                                  onTap: () {},
                                ),
                                const SizedBox(height: 4),
                                ClientInputMobileWidget(
                                  title: 'NPWP No',
                                  content: '',
                                  ctrl: ctrlNpwp,
                                ),
                              ],
                            ),
                      selectedClientType == 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClientInputMobileWidget(
                                    title: 'Mother Maiden Name',
                                    content: '',
                                    ctrl: ctrlMotherMaiden),
                                const SizedBox(height: 4),
                                ClientInputMobileWidget(
                                  title: 'Full Name',
                                  content: '',
                                  ctrl: ctrlFullName,
                                ),
                                const SizedBox(height: 4),
                                ClientInputMobileWidget(
                                  title: 'Place of Birth',
                                  content: '',
                                  ctrl: ctrlPob,
                                ),
                                const SizedBox(height: 4),
                                ClientDisplayMobileWidget(
                                    title: 'Date of Birth',
                                    content: dateSend,
                                    onTap: () {
                                      _presentDatePicker().then((value) {
                                        setStates(() {
                                          dateSend = value;
                                        });
                                      });
                                    }),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                ClientDisplayMobileWidget(
                                    title: 'Established Date',
                                    content: '',
                                    onTap: () {}),
                                const SizedBox(height: 4),
                                ClientInputMobileWidget(
                                  title: 'Full Name',
                                  content: '',
                                  ctrl: ctrlFullName,
                                ),
                              ],
                            ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: clientType[selectedClientType].value == 0 &&
                                    ctrlDate.text.isEmpty &&
                                    ctrlDate.text == '' &&
                                    ctrlKtpNo.text.isEmpty &&
                                    ctrlKtpNo.text == '' &&
                                    ctrlFullName.text.isEmpty &&
                                    ctrlFullName.text == '' &&
                                    ctrlPob.text.isEmpty &&
                                    ctrlPob.text == ''
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                        context,
                                        StringRouterUtil
                                            .clientListScreenMobileRoute,
                                        arguments: ClientMathcingModel(
                                            pDocumentType: clientType[
                                                            selectedClientType]
                                                        .value ==
                                                    0
                                                ? 'KTP'
                                                : 'NPWP',
                                            pDateOfBirth: ctrlDate.text,
                                            pDocumentNo:
                                                clientType[selectedClientType]
                                                            .value ==
                                                        'NPWP'
                                                    ? ctrlNpwp.text
                                                    : ctrlKtpNo.text,
                                            pEstDate: '',
                                            pFullName: ctrlFullName.text,
                                            pMotherMaidenName:
                                                ctrlMotherMaiden.text,
                                            pPlaceOfBirth: ctrlPob.text));
                                  },
                            child: Container(
                              width: 180,
                              height: 35,
                              decoration: BoxDecoration(
                                color:
                                    clientType[selectedClientType].value == 0 &&
                                            ctrlDate.text.isEmpty &&
                                            ctrlDate.text == '' &&
                                            ctrlKtpNo.text.isEmpty &&
                                            ctrlKtpNo.text == '' &&
                                            ctrlFullName.text.isEmpty &&
                                            ctrlFullName.text == '' &&
                                            ctrlPob.text.isEmpty &&
                                            ctrlPob.text == ''
                                        ? Colors.grey
                                        : thirdColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                  child: Text('VIEW',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: clientType[selectedClientType]
                                                          .value ==
                                                      0 &&
                                                  ctrlDate.text.isEmpty &&
                                                  ctrlDate.text == '' &&
                                                  ctrlKtpNo.text.isEmpty &&
                                                  ctrlKtpNo.text == '' &&
                                                  ctrlFullName.text.isEmpty &&
                                                  ctrlFullName.text == '' &&
                                                  ctrlPob.text.isEmpty &&
                                                  ctrlPob.text == ''
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600))),
                            ),
                          ),
                          const SizedBox(width: 16),
                          InkWell(
                            onTap: () {
                              setStates(() {
                                ctrlMotherMaiden.clear();

                                ctrlKtpNo.clear();

                                ctrlFullName.clear();

                                ctrlPob.clear();

                                ctrlNpwp.clear();

                                dateSend = '';
                              });
                            },
                            child: Container(
                              width: 180,
                              height: 35,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(8),
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
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<void> _showBottomDetail(Data data) {
    String date;
    if (data.applicationDate != null) {
      DateTime tempDate = DateFormat('yyyy-MM-dd').parse(data.applicationDate!);
      var inputDate = DateTime.parse(tempDate.toString());
      var outputFormat = DateFormat('dd/MM/yyyy');
      date = outputFormat.format(inputDate);
    } else {
      date = '';
    }
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 3),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Detail',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DetailInfoMobileWidget(
                      title: 'Application No',
                      content: data.applicationNo!,
                      type: false),
                  DetailInfoMobileWidget(
                      title: 'Branch', content: data.branchName!, type: false),
                  DetailInfoMobileWidget(
                      title: 'Application Date', content: date, type: false),
                  DetailInfoMobileWidget(
                      title: 'Facility Name',
                      content: data.facilityDesc ?? '',
                      type: true),
                  DetailInfoMobileWidget(
                      title: 'Purpose',
                      content: data.purposeLoanName ?? '-',
                      type: false),
                  DetailInfoMobileWidget(
                      title: 'Agreement No',
                      content: data.agreementNo ?? '-',
                      type: false),
                  DetailInfoMobileWidget(
                      title: 'Status',
                      content: data.applicationStatus!,
                      type: false),
                  const SizedBox(height: 16),
                  Center(
                    child: InkWell(
                      onTap: () {
                        if (data.applicationStatus == 'HOLD') {
                          Navigator.pushNamed(
                              context,
                              StringRouterUtil
                                  .applicationForm1ResumeScreenMobileRoute,
                              arguments: data.applicationNo);
                        } else {
                          Navigator.pushNamed(
                              context,
                              StringRouterUtil
                                  .applicationForm1ViewScreenMobileRoute,
                              arguments: data.applicationNo);
                        }
                      },
                      child: Container(
                        width: 180,
                        height: 35,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(8),
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
              ),
            );
          });
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
          'Application List',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: _showBottom,
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 28,
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Material(
              elevation: 6,
              shadowColor: Colors.grey.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(width: 1.0, color: Color(0xFFEAEAEA))),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.78,
                height: 45,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  decoration: InputDecoration(
                      hintText: 'search record',
                      isDense: true,
                      hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.5), fontSize: 15),
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
          BlocListener(
              bloc: appListBloc,
              listener: (_, AppListState state) {
                if (state is AppListLoading) {}
                if (state is AppListLoaded) {
                  setState(() {
                    dataFilter = state.appListResponseModel.data!
                        .where((element) => element.applicationStatus!
                            .toUpperCase()
                            .contains(widget.status.toUpperCase()))
                        .toList();
                    data.addAll(state.appListResponseModel.data!
                        .where((element) => element.applicationStatus!
                            .toUpperCase()
                            .contains(widget.status.toUpperCase()))
                        .toList());
                  });
                }
                if (state is AppListError) {}
                if (state is AppListException) {}
              },
              child: BlocBuilder(
                  bloc: appListBloc,
                  builder: (_, AppListState state) {
                    if (state is AppListLoading) {
                      return Expanded(
                        child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: 10,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(height: 8);
                                },
                                padding: const EdgeInsets.all(16),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 110,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.05)),
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
                                  );
                                })),
                      );
                    }
                    if (state is AppListLoaded) {
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            final data = await DatabaseHelper.getUserData();
                            appListBloc.add(AppListAttempt(data[0]['uid']));
                          },
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: dataFilter.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 8);
                              },
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (BuildContext context, int index) {
                                String date;
                                if (dataFilter[index].applicationDate != null) {
                                  DateTime tempDate = DateFormat('yyyy-MM-dd')
                                      .parse(
                                          dataFilter[index].applicationDate!);
                                  var inputDate =
                                      DateTime.parse(tempDate.toString());
                                  var outputFormat = DateFormat('dd/MM/yyyy');
                                  date = outputFormat.format(inputDate);
                                } else {
                                  date = '';
                                }
                                return GestureDetector(
                                  onTap: () {
                                    _showBottomDetail(dataFilter[index]);
                                  },
                                  child: Container(
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
                                      child: Stack(
                                        children: [
                                          Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Container(
                                                width: 109,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: dataFilter[index]
                                                                .applicationStatus!
                                                                .toUpperCase() ==
                                                            'ON PROCESS'
                                                        ? thirdColor
                                                        : dataFilter[index]
                                                                    .applicationStatus ==
                                                                'APPROVE'
                                                            ? primaryColor
                                                            : dataFilter[index]
                                                                        .applicationStatus ==
                                                                    'CANCEL'
                                                                ? const Color(
                                                                    0xFFFFEC3F)
                                                                : dataFilter[index]
                                                                            .applicationStatus ==
                                                                        'HOLD'
                                                                    ? secondaryColor
                                                                    : const Color(
                                                                        0xFFDF0000),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(18.0),
                                                      bottomLeft:
                                                          Radius.circular(8.0),
                                                    )),
                                                child: Center(
                                                  child: Text(
                                                    dataFilter[index]
                                                        .applicationStatus!,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: dataFilter[index]
                                                                        .applicationStatus ==
                                                                    'ON PROCESS' ||
                                                                dataFilter[index]
                                                                        .applicationStatus ==
                                                                    'CENCEL' ||
                                                                dataFilter[index]
                                                                        .applicationStatus ==
                                                                    'HOLD'
                                                            ? Colors.black
                                                            : Colors.white),
                                                  ),
                                                ),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  dataFilter[index].clientName!,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  dataFilter[index]
                                                      .applicationNo!,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  GeneralUtil.convertToIdr(
                                                      dataFilter[index]
                                                          .financingAmount,
                                                      2),
                                                  style: const TextStyle(
                                                      fontSize: 12,
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
                                                          color:
                                                              Color(0xFF643FDB),
                                                          size: 13,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          date,
                                                          style: const TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              color: Color(
                                                                  0xFF643FDB)),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: 75,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          color: secondaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      child: Center(
                                                        child: Text(
                                                          dataFilter[index]
                                                                  .facilityDesc ??
                                                              '-',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 10,
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
                      );
                    }
                    return Expanded(
                      child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: 10,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 8);
                              },
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 110,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.05)),
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
                                );
                              })),
                    );
                  })),
        ],
      ),
    );
  }
}
