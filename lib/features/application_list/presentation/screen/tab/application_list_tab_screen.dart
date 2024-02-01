import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_display_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_input_ktp_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_input_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/detail_info_widget.dart';
import 'package:sales_order/features/client_list/data/client_matching_mode.dart';
import 'package:sales_order/features/home/domain/repo/home_repo.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/database_helper.dart';
import 'package:sales_order/utility/drop_down_util.dart';
import 'package:sales_order/utility/general_util.dart';
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
  var length = 0;
  var selectedClientType = 0;
  final int _perPage = 12;
  late List<Data> data = [];
  late List<Data> dataFilter = [];
  late List<Data> dataFilterSearch = [];
  late List<CustDropdownMenuItem> clientType = [];
  late List<CustDropdownMenuItem> filter = [];
  late List<String> filterValue = ['ALL', 'HOLD', 'ON PROCESS', 'APPROVE'];
  late String filterSelect = '';
  TextEditingController ctrlDate = TextEditingController();
  @override
  void initState() {
    getMenu();
    getData();
    super.initState();
  }

  getData() async {
    final data = await DatabaseHelper.getUserData();
    appListBloc.add(AppListAttempt(data[0]['uid']));
  }

  void filterSearchResults(String query) {
    setState(() {
      dataFilterSearch = data
          .where((item) =>
              item.clientName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      dataFilter = dataFilterSearch;
      selectedPageNumber = 0;
      length = dataFilter.length;
      pagination = (dataFilterSearch.length / 12).ceil();
    });
  }

  Future<void> getMenu() async {
    setState(() {
      clientType
          .add(const CustDropdownMenuItem(value: 0, child: Text("PERSONAL")));
      clientType
          .add(const CustDropdownMenuItem(value: 1, child: Text("CORPORATE")));
      filter.add(const CustDropdownMenuItem(value: 0, child: Text("ALL")));
      filter.add(const CustDropdownMenuItem(value: 1, child: Text("HOLD")));
      filter
          .add(const CustDropdownMenuItem(value: 2, child: Text("ON PROCESS")));
      filter.add(const CustDropdownMenuItem(value: 3, child: Text("APPROVE")));
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

  Future<void> _showBottomDialog(Data data) {
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0, left: 24, right: 24),
                  child: Row(
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
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 24.0, left: 24, right: 24, bottom: 16),
                  child: Row(
                    children: [
                      DetailInfoWidget(
                          title: 'Application No',
                          content: data.applicationNo!,
                          type: false),
                      const SizedBox(width: 16),
                      DetailInfoWidget(
                          title: 'Branch',
                          content: data.branchName!,
                          type: false),
                      const SizedBox(width: 16),
                      DetailInfoWidget(
                          title: 'Application Date',
                          content: date,
                          type: false),
                      const SizedBox(width: 16),
                      DetailInfoWidget(
                          title: 'Facility Name',
                          content: data.facilityDesc ?? '',
                          type: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 32),
                  child: Row(
                    children: [
                      DetailInfoWidget(
                          title: 'Purpose',
                          content: data.purposeLoanName ?? '-',
                          type: false),
                      const SizedBox(width: 16),
                      DetailInfoWidget(
                          title: 'Agreement No',
                          content: data.agreementNo ?? '-',
                          type: false),
                      const SizedBox(width: 16),
                      DetailInfoWidget(
                          title: 'Status',
                          content: data.applicationStatus!,
                          type: false),
                    ],
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      if (data.applicationStatus == 'HOLD') {
                        Navigator.pushNamed(
                            context,
                            StringRouterUtil
                                .applicationForm1ResumeScreenTabRoute,
                            arguments: data.applicationNo);
                      } else {
                        Navigator.pushNamed(context,
                            StringRouterUtil.applicationForm1ViewScreenTabRoute,
                            arguments: data.applicationNo);
                      }
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
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        });
  }

  Future<void> _showBottomDialogClient() {
    final TextEditingController ctrlMotherMaiden = TextEditingController();
    final TextEditingController ctrlKtpNo = TextEditingController();
    final TextEditingController ctrlFullName = TextEditingController();
    final TextEditingController ctrlPob = TextEditingController();
    final TextEditingController ctrlNpwp = TextEditingController();
    String dateSend = '';
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 32.0, left: 24, right: 24),
                      child: Row(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 24.0, left: 24, right: 24, bottom: 16),
                      child: Row(
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

                                        ctrlMotherMaiden.clear();

                                        ctrlKtpNo.clear();

                                        ctrlFullName.clear();

                                        ctrlPob.clear();

                                        ctrlNpwp.clear();

                                        dateSend = '';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          selectedClientType == 0
                              ? Row(
                                  children: [
                                    ClientDisplayWidget(
                                      title: 'Document Type',
                                      content: 'KTP',
                                      onTap: () {},
                                    ),
                                    const SizedBox(width: 16),
                                    ClientInputKtpWidget(
                                      title: 'KTP No',
                                      content: '',
                                      ctrl: ctrlKtpNo,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    ClientDisplayWidget(
                                      title: 'Document Type',
                                      content: 'NPWP',
                                      onTap: () {},
                                    ),
                                    const SizedBox(width: 16),
                                    ClientInputWidget(
                                      title: 'NPWP No',
                                      content: '',
                                      ctrl: ctrlNpwp,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 32),
                      child: selectedClientType == 0
                          ? Row(
                              children: [
                                ClientInputWidget(
                                    title: 'Mother Maiden Name',
                                    content: '',
                                    ctrl: ctrlMotherMaiden),
                                const SizedBox(width: 16),
                                ClientInputWidget(
                                  title: 'Full Name',
                                  content: '',
                                  ctrl: ctrlFullName,
                                ),
                                const SizedBox(width: 16),
                                ClientInputWidget(
                                  title: 'Place of Birth',
                                  content: '',
                                  ctrl: ctrlPob,
                                ),
                                const SizedBox(width: 16),
                                ClientDisplayWidget(
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
                          : Row(children: [
                              ClientDisplayWidget(
                                  title: 'Established Date',
                                  content: '',
                                  onTap: () {}),
                              const SizedBox(width: 16),
                              ClientInputWidget(
                                title: 'Full Name',
                                content: '',
                                ctrl: ctrlFullName,
                              ),
                            ]),
                    ),
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
                                  Navigator.pushNamed(context,
                                      StringRouterUtil.clientListScreenTabRoute,
                                      arguments: ClientMathcingModel(
                                          pDocumentType:
                                              clientType[selectedClientType]
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
                            width: 200,
                            height: 45,
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
                              borderRadius: BorderRadius.circular(10),
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
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
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
                  _showBottomDialogClient();
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
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          onChanged: (value) {
                            filterSearchResults(value);
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'search record',
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
                    Row(
                      children: [
                        Container(
                          width: 180,
                          height: 45,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset:
                                      const Offset(-6, 4), // Shadow position
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xFFE1E1E1))),
                          child: CustDropDown(
                            maxListHeight: 300,
                            items: filter,
                            hintText: "Select Filter",
                            borderRadius: 5,
                            defaultSelectedIndex: 0,
                            onChanged: (val) {
                              setState(() {
                                filterSelect = filterValue[val];
                                if (filterValue[val] == 'ALL') {
                                  dataFilterSearch = [];
                                  dataFilter = data;
                                } else {
                                  dataFilterSearch = data
                                      .where((item) => item.applicationStatus!
                                          .toLowerCase()
                                          .contains(
                                              filterValue[val].toLowerCase()))
                                      .toList();
                                  dataFilter = dataFilterSearch;
                                }
                                selectedPageNumber = 0;
                                pagination = (dataFilter.length / 12).ceil();
                                length = dataFilter.length;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.filter_alt_rounded,
                          size: 32,
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                BlocListener(
                    bloc: appListBloc,
                    listener: (_, AppListState state) {
                      if (state is AppListLoading) {}
                      if (state is AppListLoaded) {
                        setState(() {
                          if (filterSelect == 'ALL' || filterSelect == '') {
                            pagination =
                                (state.appListResponseModel.data!.length / 12)
                                    .ceil();
                            length = state.appListResponseModel.data!.length;
                            if (pagination == 1) {
                              dataFilter = state.appListResponseModel.data!;
                            } else {
                              dataFilter = state.appListResponseModel.data!
                                  .sublist(
                                      (selectedPageNumber * _perPage),
                                      ((selectedPageNumber * _perPage) +
                                          _perPage));
                            }
                          } else {
                            List<Data> dataFilterTemp = [];
                            dataFilterTemp = state.appListResponseModel.data!
                                .where((element) => element.applicationStatus!
                                    .toUpperCase()
                                    .contains(filterSelect.toUpperCase()))
                                .toList();
                            pagination = (dataFilterTemp.length / 12).ceil();
                            if (pagination == 1) {
                              dataFilter = dataFilterTemp;
                            } else {
                              dataFilter = dataFilterTemp.sublist(
                                  (selectedPageNumber * _perPage),
                                  ((selectedPageNumber * _perPage) + _perPage));
                            }
                          }

                          data.addAll(state.appListResponseModel.data!);
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
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 1.0 / 0.42,
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
                            return Dismissible(
                              key: UniqueKey(),
                              direction:
                                  DismissDirection.horizontal, // or whatever
                              confirmDismiss: (direction) {
                                if (direction.name == 'endToStart') {
                                  if (selectedPageNumber < pagination - 1) {
                                    setState(() {
                                      selectedPageNumber++;
                                      if (dataFilterSearch.isEmpty) {
                                        if (selectedPageNumber ==
                                            pagination - 1) {
                                          dataFilter = data.sublist(
                                              (selectedPageNumber * _perPage),
                                              length);
                                        } else {
                                          dataFilter = data.sublist(
                                              (selectedPageNumber * _perPage),
                                              ((selectedPageNumber * _perPage) +
                                                  _perPage));
                                        }
                                      } else {
                                        if (selectedPageNumber ==
                                            pagination - 1) {
                                          dataFilter = dataFilterSearch.sublist(
                                              (selectedPageNumber * _perPage),
                                              length);
                                        } else {
                                          dataFilter = dataFilterSearch.sublist(
                                              (selectedPageNumber * _perPage),
                                              ((selectedPageNumber * _perPage) +
                                                  _perPage));
                                        }
                                      }
                                    });
                                  }
                                } else if (direction.name == 'startToEnd') {
                                  if (selectedPageNumber > 0) {
                                    setState(() {
                                      selectedPageNumber--;
                                      if (dataFilterSearch.isEmpty) {
                                        if (selectedPageNumber ==
                                            pagination - 1) {
                                          dataFilter = data.sublist(
                                              (selectedPageNumber * _perPage),
                                              length);
                                        } else {
                                          dataFilter = data.sublist(
                                              (selectedPageNumber * _perPage),
                                              ((selectedPageNumber * _perPage) +
                                                  _perPage));
                                        }
                                      } else {
                                        if (selectedPageNumber ==
                                            pagination - 1) {
                                          dataFilter = dataFilterSearch.sublist(
                                              (selectedPageNumber * _perPage),
                                              length);
                                        } else {
                                          dataFilter = dataFilterSearch.sublist(
                                              (selectedPageNumber * _perPage),
                                              ((selectedPageNumber * _perPage) +
                                                  _perPage));
                                        }
                                      }
                                    });
                                  }
                                }

                                return Future.value(
                                    false); // always deny the actual dismiss, else it will expect the widget to be removed
                              },
                              child: SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.55,
                                child: Center(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      final data =
                                          await DatabaseHelper.getUserData();
                                      appListBloc
                                          .add(AppListAttempt(data[0]['uid']));
                                    },
                                    child: GridView.count(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: 1.0 / 0.42,
                                      padding: const EdgeInsets.all(8.0),
                                      children: List.generate(dataFilter.length,
                                          (int index) {
                                        String date;
                                        if (dataFilter[index].applicationDate !=
                                            null) {
                                          DateTime tempDate =
                                              DateFormat('yyyy-MM-dd').parse(
                                                  dataFilter[index]
                                                      .applicationDate!);
                                          var inputDate = DateTime.parse(
                                              tempDate.toString());
                                          var outputFormat =
                                              DateFormat('dd/MM/yyyy');
                                          date = outputFormat.format(inputDate);
                                        } else {
                                          date = '';
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            _showBottomDialog(
                                                dataFilter[index]);
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
                                                    offset: const Offset(-6,
                                                        4), // Shadow position
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Container(
                                                      width: 109,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          color: dataFilter[
                                                                          index]
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
                                                                      : dataFilter[index].applicationStatus ==
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
                                                          dataFilter[index]
                                                              .applicationStatus!,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              color: dataFilter[index].applicationStatus == 'ON PROCESS' ||
                                                                      dataFilter[index]
                                                                              .applicationStatus ==
                                                                          'CENCEL' ||
                                                                      dataFilter[index]
                                                                              .applicationStatus ==
                                                                          'HOLD'
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          dataFilter[index]
                                                              .clientName!,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          dataFilter[index]
                                                              .applicationNo!,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        Text(
                                                          GeneralUtil.convertToIdr(
                                                              dataFilter[index]
                                                                  .financingAmount,
                                                              2),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
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
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: Color(
                                                                          0xFF643FDB)),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              height: 25,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(6.0),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      secondaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                              child: Center(
                                                                child: Text(
                                                                  dataFilter[index]
                                                                          .facilityDesc ??
                                                                      '-',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          10,
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
                                ),
                              ),
                            );
                          }
                          return SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.55,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 1.0 / 0.42,
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
                                  if (dataFilterSearch.isEmpty) {
                                    if (selectedPageNumber == pagination - 1) {
                                      dataFilter = data.sublist(
                                          (selectedPageNumber * _perPage),
                                          length);
                                    } else {
                                      dataFilter = data.sublist(
                                          (selectedPageNumber * _perPage),
                                          ((selectedPageNumber * _perPage) +
                                              _perPage));
                                    }
                                  } else {
                                    if (selectedPageNumber == pagination - 1) {
                                      dataFilter = dataFilterSearch.sublist(
                                          (selectedPageNumber * _perPage),
                                          length);
                                    } else {
                                      dataFilter = dataFilterSearch.sublist(
                                          (selectedPageNumber * _perPage),
                                          ((selectedPageNumber * _perPage) +
                                              _perPage));
                                    }
                                  }
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

                                  if (dataFilterSearch.isEmpty) {
                                    if (selectedPageNumber == pagination - 1) {
                                      dataFilter = data.sublist(
                                          (selectedPageNumber * _perPage),
                                          length);
                                    } else {
                                      dataFilter = data.sublist(
                                          (selectedPageNumber * _perPage),
                                          ((selectedPageNumber * _perPage) +
                                              _perPage));
                                    }
                                  } else {
                                    if (selectedPageNumber == pagination - 1) {
                                      dataFilter = dataFilterSearch.sublist(
                                          (selectedPageNumber * _perPage),
                                          length);
                                    } else {
                                      dataFilter = dataFilterSearch.sublist(
                                          (selectedPageNumber * _perPage),
                                          ((selectedPageNumber * _perPage) +
                                              _perPage));
                                    }
                                  }
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
                                  if (dataFilterSearch.isEmpty) {
                                    if (selectedPageNumber == pagination - 1) {
                                      dataFilter = data.sublist(
                                          (selectedPageNumber * _perPage),
                                          length);
                                    } else {
                                      dataFilter = data.sublist(
                                          (selectedPageNumber * _perPage),
                                          ((selectedPageNumber * _perPage) +
                                              _perPage));
                                    }
                                  } else {
                                    if (selectedPageNumber == pagination - 1) {
                                      dataFilter = dataFilterSearch.sublist(
                                          (selectedPageNumber * _perPage),
                                          length);
                                    } else {
                                      dataFilter = dataFilterSearch.sublist(
                                          (selectedPageNumber * _perPage),
                                          ((selectedPageNumber * _perPage) +
                                              _perPage));
                                    }
                                  }
                                });
                              },
                              child: const Icon(
                                Icons.keyboard_arrow_right_rounded,
                                size: 32,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
