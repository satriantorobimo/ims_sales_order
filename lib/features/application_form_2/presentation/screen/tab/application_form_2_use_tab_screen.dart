import 'package:sales_order/features/application_form_1/data/client_detail_response_model.dart'
    as cd;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';
import 'package:sales_order/features/application_form_2/data/add_client_request_model.dart';
import 'package:sales_order/features/application_form_2/domain/repo/form_2_repo.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/bank_bloc/bloc.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/client_bloc/bloc.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/family_bloc/bloc.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/work_bloc/bloc.dart';
import 'package:sales_order/features/application_form_3/data/update_loan_data_request_model.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/database_helper.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class ApplicationForm2UseTabScreen extends StatefulWidget {
  const ApplicationForm2UseTabScreen({super.key, required this.data});
  final cd.Data data;

  @override
  State<ApplicationForm2UseTabScreen> createState() =>
      _ApplicationForm2UseTabScreenState();
}

class _ApplicationForm2UseTabScreenState
    extends State<ApplicationForm2UseTabScreen> {
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
  bool isLoading = true;
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
    getData();
    super.initState();
  }

  void getData() {
    bankBloc.add(const BankAttempt(''));
    familyBloc.add(const FamilyAttempt('FMLYT'));
    workBloc.add(const WorkAttempt('JOB'));
    setState(() {
      if (widget.data.bankCode != null) {
        selectBankCode = widget.data.bankCode!;
      }

      if (widget.data.bankName != null) {
        selectBank = widget.data.bankName!;
      }

      if (widget.data.bankAccountName != null) {
        ctrlBankName.text = widget.data.bankAccountName!;
      }

      if (widget.data.bankAccountNo != null) {
        ctrlBankNo.text = widget.data.bankAccountNo!;
      }

      if (widget.data.familyFullName != null) {
        ctrlFullName.text = widget.data.familyFullName!;
      }

      if (widget.data.familyIdNo != null) {
        ctrlIdNo.text = widget.data.familyIdNo!;
      }

      if (widget.data.familyTypeCode != null) {
        selectFamily = widget.data.familyTypeDesc!;
        selectFamilyCode = widget.data.familyTypeCode!;
      }

      if (widget.data.familyGenderCode != null) {
        gender = widget.data.familyGenderCode! == 'M' ? 'MALE' : 'FEMALE';
      }

      if (widget.data.workCompanyName != null) {
        ctrlCompanyName.text = widget.data.workCompanyName!;
      }
      if (widget.data.workCompanyName != null) {
        ctrlCompanyName.text = widget.data.workCompanyName!;
      }

      if (widget.data.workTypeDesc != null) {
        selectWorkType = widget.data.workTypeDesc!;
        selectWorkTypeCode = widget.data.workTypeCode!;
      }

      if (widget.data.workDepartmentName != null) {
        ctrlDepartment.text = widget.data.workDepartmentName!;
      }

      if (widget.data.workPosition != null) {
        ctrlWorkPosition.text = widget.data.workPosition!;
      }

      if (widget.data.workIsLatest != null) {
        if (widget.data.workIsLatest == '1') {
          isPresent = true;
        } else {
          isPresent = false;

          DateTime tempPromDate =
              DateFormat('yyyy-MM-dd').parse(widget.data.workEndDate!);
          var inputPromDate = DateTime.parse(tempPromDate.toString());
          var outputPromFormat = DateFormat('dd MMMM yyyy');
          dataSendEnd = DateFormat('yyyy-MM-dd').format(tempPromDate);
          ctrlEnd.text = outputPromFormat.format(inputPromDate);
        }
      }

      if (widget.data.workStartDate != null) {
        DateTime tempPromDate =
            DateFormat('yyyy-MM-dd').parse(widget.data.workStartDate!);
        var inputPromDate = DateTime.parse(tempPromDate.toString());
        var outputPromFormat = DateFormat('dd MMMM yyyy');
        dataSendStart = DateFormat('yyyy-MM-dd').format(tempPromDate);
        ctrlStart.text = outputPromFormat.format(inputPromDate);
      }
      isLoading = false;
    });
  }

  Future<void> _showBottom(LookUpMsoResponseModel lookUpMsoResponseModel) {
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
                    'Family Type',
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
      LookUpMsoResponseModel lookUpMsoResponseModel) {
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
                    'Work Type',
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
                              if (selectIndexWorkType == index) {
                                selectWorkType = '';
                                selectWorkTypeCode = '';
                                selectIndexWorkType = 1000;
                              } else {
                                selectWorkType = lookUpMsoResponseModel
                                    .data![index].description!;
                                selectWorkTypeCode =
                                    lookUpMsoResponseModel.data![index].code!;
                                selectIndexWorkType = index;
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
          );
        });
  }

  Future<void> _showBottomBank(LookUpMsoResponseModel lookUpMsoResponseModel) {
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
                    'Bank',
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
                              if (selectIndexBank == index) {
                                selectBank = '';
                                selectBankCode = '';
                                selectIndexBank = 1000;
                              } else {
                                selectBank = lookUpMsoResponseModel
                                    .data![index].description!;
                                selectBankCode =
                                    lookUpMsoResponseModel.data![index].code!;
                                selectIndexBank = index;
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
          );
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
                                      '2',
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
                                      '3',
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
                  child: isLoading
                      ? _loading()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.23,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              '1. Bank',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                                    builder:
                                                        (_, BankState state) {
                                                      if (state
                                                          is BankLoading) {}
                                                      if (state is BankLoaded) {
                                                        return InkWell(
                                                          onTap: () {
                                                            _showBottomBank(state
                                                                .lookUpMsoResponseModel);
                                                          },
                                                          child: Container(
                                                            width: 280,
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
                                                              color:
                                                                  Colors.white,
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 16.0,
                                                                    right:
                                                                        16.0),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                selectBank == ''
                                                                    ? 'Select Bank'
                                                                    : selectBank,
                                                                style: TextStyle(
                                                                    color: selectBank ==
                                                                            ''
                                                                        ? Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.5)
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
                                                        );
                                                      }
                                                      return Container(
                                                        width: 280,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
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
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 16.0,
                                                                right: 16.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              '2. Bank Account No',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 280,
                                            height: 50,
                                            child: TextFormField(
                                              controller: ctrlBankNo,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'Bank Account No',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
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
                                              '3. Bank Account Name',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 280,
                                            height: 50,
                                            child: TextFormField(
                                              controller: ctrlBankName,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'Bank Account Name',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.23,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              '4. ID No',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 280,
                                            height: 50,
                                            child: TextFormField(
                                              controller: ctrlIdNo,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'ID No',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
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
                                              '5. Family Full Name',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 280,
                                            height: 50,
                                            child: TextFormField(
                                              controller: ctrlFullName,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'Family Full Name',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
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
                                              '6. Family Type',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                                listener:
                                                    (_, FamilyState state) {
                                                  if (state is FamilyLoading) {}
                                                  if (state is FamilyLoaded) {
                                                    setState(() {
                                                      selectIndexFamily = 1000;
                                                    });
                                                  }
                                                  if (state is FamilyError) {}
                                                  if (state
                                                      is FamilyException) {}
                                                },
                                                child: BlocBuilder(
                                                    bloc: familyBloc,
                                                    builder:
                                                        (_, FamilyState state) {
                                                      if (state
                                                          is FamilyLoading) {}
                                                      if (state
                                                          is FamilyLoaded) {
                                                        return InkWell(
                                                          onTap: () {
                                                            _showBottom(state
                                                                .lookUpMsoResponseModel);
                                                          },
                                                          child: Container(
                                                            width: 280,
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
                                                              color:
                                                                  Colors.white,
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 16.0,
                                                                    right:
                                                                        16.0),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                selectFamily ==
                                                                        ''
                                                                    ? 'Select Family Type'
                                                                    : selectFamily,
                                                                style: TextStyle(
                                                                    color: selectFamily ==
                                                                            ''
                                                                        ? Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.5)
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
                                                        );
                                                      }
                                                      return Container(
                                                        width: 280,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
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
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 16.0,
                                                                right: 16.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              '7. Gender',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                          height: 52,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    gender = 'MALE';
                                                  });
                                                },
                                                child: Container(
                                                  height: 40,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: gender == 'MALE'
                                                        ? primaryColor
                                                        : const Color(
                                                            0xFFE1E1E1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: const Center(
                                                      child: Text('MALE',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))),
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
                                                  height: 40,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: gender == 'FEMALE'
                                                        ? primaryColor
                                                        : const Color(
                                                            0xFFE1E1E1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: const Center(
                                                      child: Text('FEMALE',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
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
                                  ],
                                )),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.23,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: const [
                                            Text(
                                              '8. Company Name',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 280,
                                            height: 50,
                                            child: TextFormField(
                                              controller: ctrlCompanyName,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'Company Name',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
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
                                              '9. Work Type',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                                      selectIndexWorkType =
                                                          1000;
                                                    });
                                                  }
                                                  if (state is WorkError) {}
                                                  if (state is WorkException) {}
                                                },
                                                child: BlocBuilder(
                                                    bloc: workBloc,
                                                    builder:
                                                        (_, WorkState state) {
                                                      if (state
                                                          is WorkLoading) {}
                                                      if (state is WorkLoaded) {
                                                        return InkWell(
                                                          onTap: () {
                                                            _showBottomWorktype(
                                                                state
                                                                    .lookUpMsoResponseModel);
                                                          },
                                                          child: Container(
                                                            width: 280,
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
                                                              color:
                                                                  Colors.white,
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 16.0,
                                                                    right:
                                                                        16.0),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                selectWorkType ==
                                                                        ''
                                                                    ? 'Select Work Type'
                                                                    : selectWorkType,
                                                                style: TextStyle(
                                                                    color: selectWorkType ==
                                                                            ''
                                                                        ? Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.5)
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
                                                        );
                                                      }
                                                      return Container(
                                                        width: 280,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
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
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 16.0,
                                                                right: 16.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              '10. Department',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 280,
                                            height: 50,
                                            child: TextFormField(
                                              controller: ctrlDepartment,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'Department',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
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
                                              '11. Work Position',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 280,
                                            height: 50,
                                            child: TextFormField(
                                              controller: ctrlWorkPosition,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'Work Position',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.23,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              '12. Start Date',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 190,
                                            height: 50,
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: ctrlStart,
                                              onTap: _startDatePicker,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'Start Date',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
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
                                              '13. End Date',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                              shadowColor:
                                                  Colors.grey.withOpacity(0.4),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: const BorderSide(
                                                      width: 1.0,
                                                      color:
                                                          Color(0xFFEAEAEA))),
                                              child: SizedBox(
                                                width: 190,
                                                height: 50,
                                                child: TextFormField(
                                                  controller: ctrlEnd,
                                                  readOnly: true,
                                                  onTap: _endDatePicker,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      hintText: 'End Date',
                                                      isDense: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              16.0,
                                                              20.0,
                                                              20.0,
                                                              16.0),
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.5)),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            BorderSide.none,
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
                                                      DateTime temp =
                                                          DateTime.now();
                                                      ctrlEnd.text = DateFormat(
                                                              'dd MMMM yyyy')
                                                          .format(temp);
                                                      dataSendEnd = DateFormat(
                                                              'yyyy-MM-dd')
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
                                )),
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
                        bloc: clientBloc,
                        listener: (_, ClientState state) async {
                          if (state is ClientLoading) {}

                          if (state is ClientUpdateLoaded) {
                            final data = await DatabaseHelper.getUserData();
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context,
                                StringRouterUtil.applicationForm3ScreenTabRoute,
                                arguments: UpdateLoanDataRequestModel(
                                    pApplicationNo: widget.data.applicationNo,
                                    pMarketingCode: data[0]['uid'],
                                    pMarketingName: data[0]['name']));
                          }
                          if (state is ClientError) {
                            // ignore: use_build_context_synchronously
                            GeneralUtil().showSnackBar(context, state.error!);
                          }
                          if (state is ClientException) {}
                        },
                        child: BlocBuilder(
                            bloc: clientBloc,
                            builder: (_, ClientState state) {
                              if (state is ClientLoading) {
                                return const SizedBox(
                                  width: 200,
                                  height: 45,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (state is ClientUpdateLoaded) {
                                return InkWell(
                                  onTap: () {
                                    clientBloc.add(ClientUpdateAttempt(AddClientRequestModel(
                                        pApplicationNo:
                                            widget.data.applicationNo,
                                        pBankCode: selectBankCode,
                                        pBankName: selectBank,
                                        pBankAccountNo: ctrlBankNo.text,
                                        pBankAccountName: ctrlBankName.text,
                                        pFamilyFullName: ctrlFullName.text,
                                        pFamilyIdNo: ctrlIdNo.text,
                                        pFamilyTypeCode: selectFamilyCode,
                                        pFamilyGenderCode:
                                            gender == 'Male' ? 'M' : 'F',
                                        pWorkCompanyName: ctrlCompanyName.text,
                                        pWorkTypeCode: selectWorkTypeCode,
                                        pWorkDepartmentName:
                                            ctrlDepartment.text,
                                        pWorkPosition: ctrlWorkPosition.text,
                                        pWorkStartDate: dataSendStart,
                                        pWorkIsLatest: isPresent,
                                        pClientType: 'PERSONAL',
                                        pClientIdNo: widget.data.clientIdNo,
                                        pClientFullName:
                                            widget.data.clientFullName,
                                        pClientAreaMobileNo:
                                            widget.data.clientAreaMobileNo,
                                        pClientMobileNo:
                                            widget.data.clientMobileNo,
                                        pClientEmail: widget.data.clientEmail,
                                        pClientPlaceOfBirth:
                                            widget.data.clientPlaceOfBirth,
                                        pClientDateOfBirth:
                                            widget.data.clientDateOfBirth,
                                        pClientMotherMaidenName:
                                            widget.data.clientMotherMaidenName,
                                        pClientGenderCode:
                                            widget.data.clientGenderCode,
                                        pClientMaritalStatusCode:
                                            widget.data.clientMaritalStatusCode,
                                        pClientSpouseName:
                                            widget.data.clientSpouseName,
                                        pClientSpouseIdNo:
                                            widget.data.clientSpouseIdNo,
                                        pAddressProvinceCode:
                                            widget.data.addressProvinceCode,
                                        pAddressProvinceName:
                                            widget.data.addressProvinceName,
                                        pAddressCityCode:
                                            widget.data.addressCityCode,
                                        pAddressCityName:
                                            widget.data.addressCityName,
                                        pAddressZipCodeCode:
                                            widget.data.addressZipCode,
                                        pAddressZipCode:
                                            widget.data.addressZipCodeCode,
                                        pAddressZipName:
                                            widget.data.addressZipName,
                                        pAddressSubDistrict:
                                            widget.data.addressSubDistrict,
                                        pAddressVillage: widget.data.addressVillage,
                                        pAddressAddress: widget.data.addressAddress,
                                        pAddressRt: widget.data.addressRt,
                                        pAddressRw: widget.data.addressRw,
                                        pWorkEndDate: widget.data.workEndDate)));
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
                                  clientBloc.add(ClientUpdateAttempt(AddClientRequestModel(
                                      pApplicationNo: widget.data.applicationNo,
                                      pBankCode: selectBankCode,
                                      pBankName: selectBank,
                                      pBankAccountNo: ctrlBankNo.text,
                                      pBankAccountName: ctrlBankName.text,
                                      pFamilyFullName: ctrlFullName.text,
                                      pFamilyIdNo: ctrlIdNo.text,
                                      pFamilyTypeCode: selectFamilyCode,
                                      pFamilyGenderCode:
                                          gender == 'Male' ? 'M' : 'F',
                                      pWorkCompanyName: ctrlCompanyName.text,
                                      pWorkTypeCode: selectWorkTypeCode,
                                      pWorkDepartmentName: ctrlDepartment.text,
                                      pWorkPosition: ctrlWorkPosition.text,
                                      pWorkStartDate: dataSendStart,
                                      pWorkIsLatest: isPresent,
                                      pClientType: 'PERSONAL',
                                      pClientIdNo: widget.data.clientIdNo,
                                      pClientFullName:
                                          widget.data.clientFullName,
                                      pClientAreaMobileNo:
                                          widget.data.clientAreaMobileNo,
                                      pClientMobileNo:
                                          widget.data.clientMobileNo,
                                      pClientEmail: widget.data.clientEmail,
                                      pClientPlaceOfBirth:
                                          widget.data.clientPlaceOfBirth,
                                      pClientDateOfBirth:
                                          widget.data.clientDateOfBirth,
                                      pClientMotherMaidenName:
                                          widget.data.clientMotherMaidenName,
                                      pClientGenderCode:
                                          widget.data.clientGenderCode,
                                      pClientMaritalStatusCode:
                                          widget.data.clientMaritalStatusCode,
                                      pClientSpouseName:
                                          widget.data.clientSpouseName,
                                      pClientSpouseIdNo:
                                          widget.data.clientSpouseIdNo,
                                      pAddressProvinceCode:
                                          widget.data.addressProvinceCode,
                                      pAddressProvinceName:
                                          widget.data.addressProvinceName,
                                      pAddressCityCode:
                                          widget.data.addressCityCode,
                                      pAddressCityName:
                                          widget.data.addressCityName,
                                      pAddressZipCodeCode:
                                          widget.data.addressZipCode,
                                      pAddressZipCode:
                                          widget.data.addressZipCodeCode,
                                      pAddressZipName:
                                          widget.data.addressZipName,
                                      pAddressSubDistrict:
                                          widget.data.addressSubDistrict,
                                      pAddressVillage:
                                          widget.data.addressVillage,
                                      pAddressAddress:
                                          widget.data.addressAddress,
                                      pAddressRt: widget.data.addressRt,
                                      pAddressRw: widget.data.addressRw,
                                      pWorkEndDate: widget.data.workEndDate)));
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
