import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_2/domain/repo/form_2_repo.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/bank_bloc/bloc.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/client_bloc/bloc.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/family_bloc/bloc.dart';
import 'package:sales_order/features/application_form_2/presentation/bloc/work_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/data/client_detail_response_model.dart'
    as cd;
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class ApplicationForm2ViewMobileScreen extends StatefulWidget {
  const ApplicationForm2ViewMobileScreen({super.key, required this.data});
  final cd.Data data;

  @override
  State<ApplicationForm2ViewMobileScreen> createState() =>
      _ApplicationForm2ViewMobileScreenState();
}

class _ApplicationForm2ViewMobileScreenState
    extends State<ApplicationForm2ViewMobileScreen> {
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
          DateTime tempPromDate = DateTime.now();
          var inputPromDate = DateTime.parse(tempPromDate.toString());
          var outputPromFormat = DateFormat('dd MMMM yyyy');
          dataSendEnd = DateFormat('yyyy-MM-dd').format(tempPromDate);
          ctrlEnd.text = outputPromFormat.format(inputPromDate);
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
        body: isLoading
            ? _loading()
            : SingleChildScrollView(
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
                                    selectBank,
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Bank Account No',
                                        isDense: true,
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        filled: true,
                                        fillColor: const Color(0xFFFAF9F9),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Bank Account Name',
                                        isDense: true,
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        filled: true,
                                        fillColor: const Color(0xFFFAF9F9),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'ID No',
                                        isDense: true,
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        filled: true,
                                        fillColor: const Color(0xFFFAF9F9),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Family Full Name',
                                        isDense: true,
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        filled: true,
                                        fillColor: const Color(0xFFFAF9F9),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    selectFamily,
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
                                      onTap: () {},
                                      child: Container(
                                        height: 38,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: gender == 'MALE'
                                              ? primaryColor
                                              : const Color(0xFFE1E1E1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                            child: Text('Male',
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
                                        height: 38,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: gender == 'FEMALE'
                                              ? primaryColor
                                              : const Color(0xFFE1E1E1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                            child: Text('Female',
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Company Name',
                                        isDense: true,
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        filled: true,
                                        fillColor: const Color(0xFFFAF9F9),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    selectWorkType,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Department',
                                        isDense: true,
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        filled: true,
                                        fillColor: const Color(0xFFFAF9F9),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Work Position',
                                        isDense: true,
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        filled: true,
                                        fillColor: const Color(0xFFFAF9F9),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 45,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: ctrlStart,
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(
                                            color: Color(0xFF6E6E6E)),
                                        decoration: InputDecoration(
                                            hintText: 'Start Date',
                                            isDense: true,
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
                                            filled: true,
                                            fillColor: const Color(0xFFFAF9F9),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        shadowColor:
                                            Colors.grey.withOpacity(0.4),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: const BorderSide(
                                                width: 1.0,
                                                color: Color(0xFFEAEAEA))),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          height: 45,
                                          child: TextFormField(
                                            controller: ctrlEnd,
                                            readOnly: true,
                                            keyboardType: TextInputType.text,
                                            style: const TextStyle(
                                                color: Color(0xFF6E6E6E)),
                                            decoration: InputDecoration(
                                                hintText: 'End Date',
                                                isDense: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        16.0, 20.0, 20.0, 16.0),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(0.5)),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFFAF9F9),
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
                                          onChanged: null,
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context,
                                  StringRouterUtil
                                      .applicationForm3ViewScreenMobileRoute,
                                  arguments: widget.data.applicationNo);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
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
                    const SizedBox(height: 16),
                  ],
                ),
              ));
  }

  Widget _loading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return const Padding(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              child: Divider(),
            );
          },
          itemCount: 10,
          padding: const EdgeInsets.all(16.0),
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
