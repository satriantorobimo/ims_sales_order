import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/empty_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_2/data/add_client_request_model.dart';
import 'package:sales_order/features/application_form_2/domain/repo/form_2_repo.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/bank_bloc/bloc.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/client_bloc/bloc.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/family_bloc/bloc.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/work_bloc/bloc.dart';
import 'package:sales_order/features/application_form_3/data/update_loan_data_request_model.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart'
    as lookup;

class ApplicationForm2MobileScreen extends StatefulWidget {
  const ApplicationForm2MobileScreen(
      {super.key, required this.addClientRequestModel});
  final AddClientRequestModel addClientRequestModel;

  @override
  State<ApplicationForm2MobileScreen> createState() =>
      _ApplicationForm2MobileScreenState();
}

class _ApplicationForm2MobileScreenState
    extends State<ApplicationForm2MobileScreen> {
  String gender = 'MALE';
  bool isPresent = false;
  int selectIndexFamily = 0;
  String selectFamily = '';
  String selectFamilyCode = '';
  int selectIndexWorkType = 0;
  String selectWorkType = '';
  String selectWorkTypeCode = '';
  int selectIndexBank = 0;
  String selectBank = '';
  String selectBankCode = '';
  String dataSendStart = '';
  String dataSendEnd = '';
  String appNo = '';
  BankBloc bankBloc = BankBloc(form2repo: Form2Repo());
  WorkBloc workBloc = WorkBloc(form2repo: Form2Repo());
  FamilyBloc familyBloc = FamilyBloc(form2repo: Form2Repo());
  ClientBloc clientBloc = ClientBloc(form2repo: Form2Repo());
  TextEditingController ctrlBankNo = TextEditingController();
  TextEditingController ctrlBankName = TextEditingController();
  TextEditingController ctrlIdNo = TextEditingController();
  TextEditingController ctrlFullName = TextEditingController();
  TextEditingController ctrlCompanyName = TextEditingController();
  TextEditingController ctrlDepartment = TextEditingController();
  TextEditingController ctrlWorkPosition = TextEditingController();
  TextEditingController ctrlStart = TextEditingController();
  TextEditingController ctrlEnd = TextEditingController();

  @override
  void initState() {
    bankBloc.add(const BankAttempt(''));
    familyBloc.add(const FamilyAttempt('FMLYT'));
    workBloc.add(const WorkAttempt('JOB'));
    super.initState();
  }

  Future<void> _showBottom(
      lookup.LookUpMsoResponseModel lookUpMsoResponseModel) {
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
                  padding: EdgeInsets.only(top: 16.0, left: 8, right: 8),
                  child: Text(
                    'Family Type',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                ),
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      itemCount: lookUpMsoResponseModel.data!.length,
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
                              if (selectIndexFamily == index) {
                                selectFamily = '';
                                selectFamilyCode = '';
                                selectIndexFamily = 1000;
                              } else {
                                selectFamily = lookUpMsoResponseModel
                                    .data![index].description!;
                                selectFamilyCode =
                                    lookUpMsoResponseModel.data![index].code!;
                                selectIndexFamily = index;
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lookUpMsoResponseModel
                                    .data![index].description!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              selectIndexFamily == index
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

  Future<void> _showBottomWorktype(
      lookup.LookUpMsoResponseModel lookUpMsoResponseModel) {
    List<lookup.Data> tempList = [];
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
                        'Work Type',
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
                                tempList = lookUpMsoResponseModel.data!
                                    .where((item) => item.description!
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
                              : lookUpMsoResponseModel.data!.length,
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
                                  if (selectIndexWorkType == index) {
                                    selectWorkType = '';
                                    selectWorkTypeCode = '';
                                    selectIndexWorkType = 1000;
                                  } else {
                                    selectWorkType = tempList.isNotEmpty
                                        ? tempList[index].description!
                                        : lookUpMsoResponseModel
                                            .data![index].description!;
                                    selectWorkTypeCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpMsoResponseModel
                                            .data![index].code!;
                                    selectIndexWorkType = index;
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
                                        ? tempList[index].description!
                                        : lookUpMsoResponseModel
                                            .data![index].description!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  selectIndexWorkType == index
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

  Future<void> _showBottomBank(
      lookup.LookUpMsoResponseModel lookUpMsoResponseModel) {
    List<lookup.Data> tempList = [];
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
                        'Bank',
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
                                tempList = lookUpMsoResponseModel.data!
                                    .where((item) => item.description!
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
                              : lookUpMsoResponseModel.data!.length,
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
                                  if (selectIndexBank == index) {
                                    selectBank = '';
                                    selectBankCode = '';
                                    selectIndexBank = 1000;
                                  } else {
                                    selectBank = tempList.isNotEmpty
                                        ? tempList[index].description!
                                        : lookUpMsoResponseModel
                                            .data![index].description!;
                                    selectBankCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpMsoResponseModel
                                            .data![index].code!;
                                    selectIndexBank = index;
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
                                        ? tempList[index].description!
                                        : lookUpMsoResponseModel
                                            .data![index].description!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  selectIndexBank == index
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

  void _startDatePicker() {
    showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: DateTime.now(),
            lastDate: DateTime.now(),
            firstDate: DateTime.now().add(const Duration(days: -15000)))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        setState(() {
          ctrlStart.text = DateFormat('dd MMMM yyyy').format(pickedDate);
          dataSendStart = DateFormat('yyyy-MM-dd').format(pickedDate);
        });
      });
    });
  }

  void _endDatePicker() {
    showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: DateTime.now(),
            lastDate: DateTime.now(),
            firstDate: DateTime.now().add(const Duration(days: -15000)))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        setState(() {
          ctrlEnd.text = DateFormat('dd MMMM yyyy').format(pickedDate);
          dataSendEnd = DateFormat('yyyy-MM-dd').format(pickedDate);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 8, top: 16, bottom: 8),
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
            'Client Data',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '1. Bank',
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
                                bloc: bankBloc,
                                listener: (_, BankState state) {
                                  if (state is BankLoading) {}
                                  if (state is BankLoaded) {
                                    setState(() {
                                      selectIndexBank = 1000;
                                    });
                                  }
                                  if (state is BankError) {}
                                  if (state is BankException) {}
                                },
                                child: BlocBuilder(
                                    bloc: bankBloc,
                                    builder: (_, BankState state) {
                                      if (state is BankLoading) {}
                                      if (state is BankLoaded) {
                                        return InkWell(
                                          onTap: () {
                                            _showBottomBank(
                                                state.lookUpMsoResponseModel);
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
                                                selectBank == ''
                                                    ? 'Select Bank'
                                                    : selectBank,
                                                style: TextStyle(
                                                    color: selectBank == ''
                                                        ? Colors.grey
                                                            .withOpacity(0.5)
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
                                              color:
                                                  Colors.grey.withOpacity(0.1)),
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
                                                fontWeight: FontWeight.w400),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '2. Bank Account No',
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
                        Material(
                          elevation: 6,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFFEAEAEA))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              controller: ctrlBankNo,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  hintText: 'Bank Account No',
                                  isDense: true,
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
                              '3. Bank Account Name',
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
                        Material(
                          elevation: 6,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFFEAEAEA))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              controller: ctrlBankName,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Bank Account Name',
                                  isDense: true,
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
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 8,
                color: Colors.grey.withOpacity(0.05),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '4. ID Family No',
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
                        Material(
                          elevation: 6,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFFEAEAEA))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              controller: ctrlIdNo,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(16),
                              ],
                              decoration: InputDecoration(
                                  hintText: 'ID No',
                                  isDense: true,
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
                              '5. Family Full Name',
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
                        Material(
                          elevation: 6,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFFEAEAEA))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              controller: ctrlFullName,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Family Full Name',
                                  isDense: true,
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
                              '6. Family Type',
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
                                bloc: familyBloc,
                                listener: (_, FamilyState state) {
                                  if (state is FamilyLoading) {}
                                  if (state is FamilyLoaded) {
                                    setState(() {
                                      selectIndexFamily = 1000;
                                    });
                                  }
                                  if (state is FamilyError) {}
                                  if (state is FamilyException) {}
                                },
                                child: BlocBuilder(
                                    bloc: familyBloc,
                                    builder: (_, FamilyState state) {
                                      if (state is FamilyLoading) {}
                                      if (state is FamilyLoaded) {
                                        return InkWell(
                                          onTap: () {
                                            _showBottom(
                                                state.lookUpMsoResponseModel);
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
                                                selectFamily == ''
                                                    ? 'Select Family Type'
                                                    : selectFamily,
                                                style: TextStyle(
                                                    color: selectFamily == ''
                                                        ? Colors.grey
                                                            .withOpacity(0.5)
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
                                              color:
                                                  Colors.grey.withOpacity(0.1)),
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
                                                fontWeight: FontWeight.w400),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '7. Family Gender',
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
                        SizedBox(
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    gender = 'MALE';
                                  });
                                },
                                child: Container(
                                  height: 38,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: gender == 'MALE'
                                        ? primaryColor
                                        : const Color(0xFFE1E1E1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                      child: Text('MALE',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600))),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    gender = 'FEMALE';
                                  });
                                },
                                child: Container(
                                  height: 38,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: gender == 'FEMALE'
                                        ? primaryColor
                                        : const Color(0xFFE1E1E1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                      child: Text('FEMALE',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 8,
                color: Colors.grey.withOpacity(0.05),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              '8. Company Name',
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
                        Material(
                          elevation: 6,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFFEAEAEA))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              controller: ctrlCompanyName,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Company Name',
                                  isDense: true,
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
                              '9. Work Type',
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
                                bloc: workBloc,
                                listener: (_, WorkState state) {
                                  if (state is WorkLoading) {}
                                  if (state is WorkLoaded) {
                                    setState(() {
                                      selectIndexWorkType = 1000;
                                    });
                                  }
                                  if (state is WorkError) {}
                                  if (state is WorkException) {}
                                },
                                child: BlocBuilder(
                                    bloc: workBloc,
                                    builder: (_, WorkState state) {
                                      if (state is WorkLoading) {}
                                      if (state is WorkLoaded) {
                                        return InkWell(
                                          onTap: () {
                                            _showBottomWorktype(
                                                state.lookUpMsoResponseModel);
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
                                                selectWorkType == ''
                                                    ? 'Select Work Type'
                                                    : selectWorkType,
                                                style: TextStyle(
                                                    color: selectWorkType == ''
                                                        ? Colors.grey
                                                            .withOpacity(0.5)
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
                                              color:
                                                  Colors.grey.withOpacity(0.1)),
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
                                                fontWeight: FontWeight.w400),
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
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '10. Department',
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
                        Material(
                          elevation: 6,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFFEAEAEA))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              controller: ctrlDepartment,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Department',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      16.0, 20.0, 20.0, 16.0),
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
                              '11. Work Position',
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
                        Material(
                          elevation: 6,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFFEAEAEA))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              controller: ctrlWorkPosition,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Work Position',
                                  isDense: true,
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
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '12. Work Start Date',
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
                            Material(
                              elevation: 6,
                              shadowColor: Colors.grey.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      width: 1.0, color: Color(0xFFEAEAEA))),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 45,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: ctrlStart,
                                  onTap: _startDatePicker,
                                  textAlign: TextAlign.left,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: 'Start Date',
                                      isDense: true,
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
                                  '13. Work End Date',
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
                            Row(
                              children: [
                                Material(
                                  elevation: 6,
                                  shadowColor: Colors.grey.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                          width: 1.0,
                                          color: Color(0xFFEAEAEA))),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 45,
                                    child: TextFormField(
                                      controller: ctrlEnd,
                                      readOnly: true,
                                      onTap: isPresent
                                          ? null
                                          : () {
                                              _endDatePicker();
                                            },
                                      keyboardType: TextInputType.text,
                                      textAlign: TextAlign.left,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: TextStyle(
                                        color: isPresent
                                            ? const Color(0xFF6E6E6E)
                                            : Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                          hintText: 'End Date',
                                          isDense: true,
                                          hintStyle: TextStyle(
                                              color:
                                                  Colors.grey.withOpacity(0.5)),
                                          filled: true,
                                          fillColor: isPresent
                                              ? const Color(0xFFFAF9F9)
                                              : Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    activeColor: primaryColor,
                                    value: isPresent,
                                    onChanged: (newValue) {
                                      setState(() {
                                        isPresent = newValue!;
                                        if (newValue) {
                                          DateTime temp = DateTime.now();
                                          ctrlEnd.text =
                                              DateFormat('dd MMMM yyyy')
                                                  .format(temp);
                                          dataSendEnd = DateFormat('yyyy-MM-dd')
                                              .format(temp);
                                        } else {
                                          ctrlEnd.clear();
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Present',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
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
                        width: MediaQuery.of(context).size.width * 0.45,
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
                        bloc: clientBloc,
                        listener: (_, ClientState state) {
                          if (state is ClientLoading) {}
                          if (state is ClientAddLoaded) {
                            appNo = state.addClientResponseModel.code!;
                            clientBloc.add(ClientUpdateAttempt(AddClientRequestModel(
                                pApplicationNo:
                                    state.addClientResponseModel.code,
                                pBankCode: selectBankCode,
                                pBankName: selectBank,
                                pBankAccountNo: ctrlBankNo.text,
                                pBankAccountName: ctrlBankName.text,
                                pFamilyFullName: ctrlFullName.text,
                                pFamilyIdNo: ctrlIdNo.text,
                                pFamilyTypeCode: selectFamilyCode,
                                pFamilyGenderCode: gender == 'MALE' ? 'M' : 'F',
                                pWorkCompanyName: ctrlCompanyName.text,
                                pWorkTypeCode: selectWorkTypeCode,
                                pWorkDepartmentName: ctrlDepartment.text,
                                pWorkPosition: ctrlWorkPosition.text,
                                pWorkStartDate: dataSendStart,
                                pWorkIsLatest: isPresent,
                                pClientType:
                                    widget.addClientRequestModel.pClientType,
                                pClientIdNo: widget.addClientRequestModel.pIdNo,
                                pClientFullName:
                                    widget.addClientRequestModel.pFullName,
                                pClientAreaMobileNo: widget
                                    .addClientRequestModel.pClientAreaMobileNo,
                                pClientMobileNo: widget
                                    .addClientRequestModel.pClientMobileNo,
                                pClientEmail:
                                    widget.addClientRequestModel.pClientEmail,
                                pClientPlaceOfBirth:
                                    widget.addClientRequestModel.pPlaceOfBirth,
                                pClientDateOfBirth:
                                    widget.addClientRequestModel.pDateOfBirth,
                                pClientMotherMaidenName: widget
                                    .addClientRequestModel.pMotherMaidenName,
                                pClientGenderCode: widget
                                    .addClientRequestModel.pClientGenderCode,
                                pClientMaritalStatusCode: widget
                                    .addClientRequestModel
                                    .pClientMaritalStatusCode,
                                pClientSpouseName: widget
                                    .addClientRequestModel.pClientSpouseName,
                                pClientSpouseIdNo:
                                    widget.addClientRequestModel.pClientSpouseIdNo,
                                pAddressProvinceCode: widget.addClientRequestModel.pAddressProvinceCode,
                                pAddressProvinceName: widget.addClientRequestModel.pAddressProvinceName,
                                pAddressCityCode: widget.addClientRequestModel.pAddressCityCode,
                                pAddressCityName: widget.addClientRequestModel.pAddressCityName,
                                pAddressZipCodeCode: widget.addClientRequestModel.pAddressZipCodeCode,
                                pAddressZipCode: widget.addClientRequestModel.pAddressZipCode,
                                pAddressZipName: widget.addClientRequestModel.pAddressZipName,
                                pAddressSubDistrict: widget.addClientRequestModel.pAddressSubDistrict,
                                pAddressVillage: widget.addClientRequestModel.pAddressSubDistrict,
                                pAddressAddress: widget.addClientRequestModel.pAddressAddress,
                                pAddressRt: widget.addClientRequestModel.pAddressRt,
                                pAddressRw: widget.addClientRequestModel.pAddressRw,
                                pWorkEndDate: dataSendEnd)));
                          }
                          if (state is ClientUpdateLoaded) {
                            Navigator.pushNamed(
                                context,
                                StringRouterUtil
                                    .applicationForm3ScreenMobileRoute,
                                arguments:
                                    UpdateLoanDataRequestModel(
                                        pApplicationNo: appNo,
                                        pMarketingCode: widget
                                            .addClientRequestModel
                                            .pMarketingCode,
                                        pMarketingName: widget
                                            .addClientRequestModel
                                            .pMarketingName));
                          }
                          if (state is ClientError) {
                            GeneralUtil().showSnackBar(context, state.error!);
                          }
                          if (state is ClientException) {}
                        },
                        child: BlocBuilder(
                            bloc: clientBloc,
                            builder: (_, ClientState state) {
                              if (state is ClientLoading) {
                                return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height: 45,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state is ClientAddLoaded) {
                                return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height: 45,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state is ClientUpdateLoaded) {
                                return InkWell(
                                  onTap: () {
                                    if (ctrlBankNo.text.isEmpty ||
                                        ctrlBankNo.text == '' ||
                                        ctrlBankName.text.isEmpty ||
                                        ctrlBankName.text == '' ||
                                        ctrlIdNo.text.isEmpty ||
                                        ctrlIdNo.text == '' ||
                                        ctrlFullName.text.isEmpty ||
                                        ctrlFullName.text == '' ||
                                        ctrlCompanyName.text.isEmpty ||
                                        ctrlCompanyName.text == '' ||
                                        ctrlDepartment.text.isEmpty ||
                                        ctrlDepartment.text == '' ||
                                        ctrlWorkPosition.text.isEmpty ||
                                        ctrlWorkPosition.text == '' ||
                                        ctrlStart.text.isEmpty ||
                                        ctrlStart.text == '' ||
                                        ctrlEnd.text.isEmpty ||
                                        ctrlEnd.text == '' ||
                                        selectFamily == '' ||
                                        selectWorkType == '' ||
                                        selectBank == '' ||
                                        selectBank == '') {
                                      EmptyWidget().showBottomEmpty(context);
                                    } else {
                                      clientBloc.add(ClientAddAttempt(
                                          widget.addClientRequestModel));
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
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
                                  if (ctrlBankNo.text.isEmpty ||
                                      ctrlBankNo.text == '' ||
                                      ctrlBankName.text.isEmpty ||
                                      ctrlBankName.text == '' ||
                                      ctrlIdNo.text.isEmpty ||
                                      ctrlIdNo.text == '' ||
                                      ctrlFullName.text.isEmpty ||
                                      ctrlFullName.text == '' ||
                                      ctrlCompanyName.text.isEmpty ||
                                      ctrlCompanyName.text == '' ||
                                      ctrlDepartment.text.isEmpty ||
                                      ctrlDepartment.text == '' ||
                                      ctrlWorkPosition.text.isEmpty ||
                                      ctrlWorkPosition.text == '' ||
                                      ctrlStart.text.isEmpty ||
                                      ctrlStart.text == '' ||
                                      ctrlEnd.text.isEmpty ||
                                      ctrlEnd.text == '' ||
                                      selectFamily == '' ||
                                      selectWorkType == '' ||
                                      selectBank == '' ||
                                      selectBank == '') {
                                    EmptyWidget().showBottomEmpty(context);
                                  } else {
                                    clientBloc.add(ClientAddAttempt(
                                        widget.addClientRequestModel));
                                  }
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
                              );
                            })),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ));
  }
}
