import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_form_1/data/client_detail_response_model.dart'
    as cd;
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';
import 'package:sales_order/features/application_form_1/data/zip_code_response_model.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/check_scoring_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/city_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/get_client_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/prov_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/zip_code_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/cancel_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/empty_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/wrong_widget.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/marital_status_bloc/bloc.dart';

class ApplicationForm1ResumeTabScreen extends StatefulWidget {
  const ApplicationForm1ResumeTabScreen(
      {super.key, required this.applicationNo});
  final String applicationNo;
  @override
  State<ApplicationForm1ResumeTabScreen> createState() =>
      _ApplicationForm1ResumeTabScreenState();
}

class _ApplicationForm1ResumeTabScreenState
    extends State<ApplicationForm1ResumeTabScreen> {
  String gender = 'Male';
  String selectMaritalStatus = '';
  int selectIndexMaritalStatus = 0;
  String selectProv = '';
  String selectProvCode = '';
  int selectIndexProv = 0;
  String selectCity = '';
  String selectCityCode = '';
  int selectIndexCity = 0;
  String selectPostal = '';
  String selectPostalCode = '';
  String selectPostalName = '';
  int selectIndexPostal = 0;
  String dateSend = '';
  int dateOb = 0;
  bool isLoading = true;
  String applicationNo = '';
  late String date;
  DateTime? _selectedDate = DateTime.now();
  TextEditingController ctrlDate = TextEditingController();
  TextEditingController ctrlIdNo = TextEditingController();
  TextEditingController ctrlFullName = TextEditingController();
  TextEditingController ctrlPob = TextEditingController();
  TextEditingController ctrlMotherName = TextEditingController();
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPhoneCode = TextEditingController();
  TextEditingController ctrlPhoneNumber = TextEditingController();
  TextEditingController ctrlSpouseName = TextEditingController();
  TextEditingController ctrlSpouseId = TextEditingController();
  TextEditingController ctrlSubDistrict = TextEditingController();
  TextEditingController ctrlSubVillage = TextEditingController();
  TextEditingController ctrlAddress = TextEditingController();
  TextEditingController ctrlRt = TextEditingController();
  TextEditingController ctrlRw = TextEditingController();
  TextEditingController ctrlStatus = TextEditingController();
  MaritalStatusBloc maritalStatusBloc =
      MaritalStatusBloc(form1repo: Form1Repo());
  ProvBloc provBloc = ProvBloc(form1repo: Form1Repo());
  CityBloc cityBloc = CityBloc(form1repo: Form1Repo());
  ZipCodeBloc zipCodeBloc = ZipCodeBloc(form1repo: Form1Repo());
  CheckScoringBloc checkScoringBloc = CheckScoringBloc(form1repo: Form1Repo());
  GetClientBloc getClientBloc = GetClientBloc(form1repo: Form1Repo());
  cd.Data clientDetailResponseModel = cd.Data();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getClientBloc.add(GetClientAttempt(widget.applicationNo));
    super.initState();
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
                    'Province',
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
                              if (selectIndexProv == index) {
                                selectProv = '';
                                selectProvCode = '';
                                selectIndexProv = 10000;
                                selectCity = '';
                                selectCityCode = '';
                                selectIndexCity = 10000;
                                selectPostal = '';
                                selectPostalCode = '';
                                selectIndexPostal = 10000;
                                selectPostalName = '';
                              } else {
                                cityBloc.add(CityAttempt(
                                    lookUpMsoResponseModel.data![index].code!));
                                selectProv = lookUpMsoResponseModel
                                    .data![index].description!;
                                selectProvCode =
                                    lookUpMsoResponseModel.data![index].code!;
                                selectIndexProv = index;
                                selectCity = '';
                                selectCityCode = '';
                                selectIndexCity = 10000;
                                selectPostal = '';
                                selectPostalCode = '';
                                selectIndexPostal = 10000;
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
                              selectIndexCity == index
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

  Future<void> _showBottomCity(LookUpMsoResponseModel lookUpMsoResponseModel) {
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
                    'City',
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
                              if (selectIndexCity == index) {
                                selectCity = '';
                                selectCityCode = '';
                                selectIndexCity = 10000;
                                selectPostal = '';
                                selectPostalCode = '';
                                selectIndexPostal = 10000;
                                selectPostalName = '';
                              } else {
                                zipCodeBloc.add(ZipCodeAttempt(
                                    lookUpMsoResponseModel.data![index].code!));
                                selectCity = lookUpMsoResponseModel
                                    .data![index].description!;
                                selectCityCode =
                                    lookUpMsoResponseModel.data![index].code!;
                                selectIndexCity = index;
                                selectPostal = '';
                                selectPostalCode = '';
                                selectIndexPostal = 10000;
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
                              selectIndexCity == index
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

  Future<void> _showBottomPostal(ZipCodeResponseModel zipCodeResponseModel) {
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
                    'Postal',
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
                      itemCount: zipCodeResponseModel.data!.length,
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
                              if (selectIndexPostal == index) {
                                selectPostal = '';
                                selectPostalCode = '';
                                selectIndexPostal = 1000;
                              } else {
                                selectPostal = zipCodeResponseModel
                                    .data![index].postalCode!;
                                selectPostalCode =
                                    zipCodeResponseModel.data![index].code!;
                                selectPostalName = zipCodeResponseModel
                                    .data![index].zipCodeName!;
                                selectIndexPostal = index;
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${zipCodeResponseModel.data![index].postalCode!} - ${zipCodeResponseModel.data![index].village!}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              selectIndexPostal == index
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

  Future<void> _showBottomMaritalStatus(
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
                    'Marital Status',
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
                              selectMaritalStatus = lookUpMsoResponseModel
                                  .data![index].description!;
                              selectIndexMaritalStatus = index;
                              if (selectMaritalStatus == 'MARRIED') {
                                dateOb = -6935;
                              } else if (selectMaritalStatus == 'SINGLE') {
                                dateOb = -7665;
                                ctrlSpouseId.clear();
                                ctrlSpouseName.clear();
                              } else {
                                dateOb = -6570;
                                ctrlSpouseId.clear();
                                ctrlSpouseName.clear();
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
                              selectIndexMaritalStatus == index
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

  void _presentDatePicker() {
    showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: DateTime.now().add(Duration(days: dateOb)),
            lastDate: DateTime.now().add(Duration(days: dateOb)),
            firstDate: DateTime.now().add(const Duration(days: -15000)))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        setState(() {
          ctrlDate.text = DateFormat('dd MMMM yyyy').format(_selectedDate!);
          dateSend = DateFormat('yyyy-MM-dd').format(_selectedDate!);
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
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 24, top: 16, bottom: 8),
                child: InkWell(
                  onTap: () {
                    CancelWidget()
                        .showBottomCancel(context, widget.applicationNo);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.redAccent,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
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
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener(
                        bloc: getClientBloc,
                        listener: (_, GetClientState state) {
                          if (state is GetClientLoading) {}
                          if (state is GetClientLoaded) {
                            setState(() {
                              clientDetailResponseModel =
                                  state.clientDetailResponseModel.data![0];
                              clientDetailResponseModel.applicationNo =
                                  widget.applicationNo;
                              if (state.clientDetailResponseModel.data![0]
                                      .clientDateOfBirth !=
                                  null) {
                                DateTime tempPromDate = DateFormat('yyyy-MM-dd')
                                    .parse(state.clientDetailResponseModel
                                        .data![0].clientDateOfBirth!);
                                var inputPromDate =
                                    DateTime.parse(tempPromDate.toString());
                                var outputPromFormat =
                                    DateFormat('dd MMMM yyyy');
                                dateSend = DateFormat('yyyy-MM-dd')
                                    .format(tempPromDate);
                                ctrlDate.text =
                                    outputPromFormat.format(inputPromDate);
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .clientIdNo !=
                                  null) {
                                ctrlIdNo.text = state.clientDetailResponseModel
                                    .data![0].clientIdNo!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .clientFullName !=
                                  null) {
                                ctrlFullName.text = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .clientFullName!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .clientPlaceOfBirth !=
                                  null) {
                                ctrlPob.text = state.clientDetailResponseModel
                                    .data![0].clientPlaceOfBirth!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .clientMotherMaidenName !=
                                  null) {
                                ctrlMotherName.text = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .clientMotherMaidenName!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .clientGenderType !=
                                  null) {
                                gender = state.clientDetailResponseModel
                                    .data![0].clientGenderType!
                                    .toLowerCase()
                                    .capitalizeOnlyFirstLater();
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .clientMaritalStatusType !=
                                  null) {
                                selectMaritalStatus = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .clientMaritalStatusType!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .clientEmail !=
                                  null) {
                                ctrlEmail.text = state.clientDetailResponseModel
                                    .data![0].clientEmail!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .clientAreaMobileNo !=
                                  null) {
                                ctrlPhoneCode.text = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .clientAreaMobileNo!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .clientMobileNo !=
                                  null) {
                                ctrlPhoneNumber.text = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .clientMobileNo!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .clientSpouseName !=
                                  null) {
                                ctrlSpouseName.text = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .clientSpouseName!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .clientSpouseIdNo !=
                                  null) {
                                ctrlSpouseId.text = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .clientSpouseIdNo!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .addressProvinceCode !=
                                  null) {
                                selectProv = state.clientDetailResponseModel
                                    .data![0].addressProvinceName!;
                                selectProvCode = state.clientDetailResponseModel
                                    .data![0].addressProvinceCode!;
                                cityBloc.add(CityAttempt(selectProvCode));
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .addressCityName !=
                                  null) {
                                selectCity = state.clientDetailResponseModel
                                    .data![0].addressCityName!;
                                selectCityCode = state.clientDetailResponseModel
                                    .data![0].addressCityCode!;
                                zipCodeBloc.add(ZipCodeAttempt(selectCityCode));
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .addressZipName !=
                                  null) {
                                selectPostal = state.clientDetailResponseModel
                                    .data![0].addressZipCode!;
                                selectPostalName = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .addressZipName!;
                                selectPostalCode = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .addressZipCodeCode!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .addressSubDistrict !=
                                  null) {
                                ctrlSubDistrict.text = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .addressSubDistrict!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .addressVillage !=
                                  null) {
                                ctrlSubVillage.text = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .addressVillage!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .addressAddress !=
                                  null) {
                                ctrlAddress.text = state
                                    .clientDetailResponseModel
                                    .data![0]
                                    .addressAddress!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .addressRt !=
                                  null) {
                                ctrlRt.text = state.clientDetailResponseModel
                                    .data![0].addressRt!;
                              }
                              if (state.clientDetailResponseModel.data![0]
                                      .addressRw !=
                                  null) {
                                ctrlRw.text = state.clientDetailResponseModel
                                    .data![0].addressRw!;
                              }
                              isLoading = false;
                            });
                            maritalStatusBloc
                                .add(const MaritalStatusAttempt('MRTYP'));
                            provBloc.add(const ProvAttempt(''));
                          }
                          if (state is GetClientError) {
                            GeneralUtil().showSnackBar(context, state.error!);
                          }
                          if (state is GetClientException) {}
                        },
                      ),
                    ],
                    child: isLoading
                        ? _loading()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.23,
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
                                                '1. ID No',
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
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      16),
                                                ],
                                                decoration: InputDecoration(
                                                    hintText: 'ID NO',
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(16.0,
                                                            20.0, 20.0, 16.0),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.5)),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
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
                                            children: const [
                                              Text(
                                                '2. Full Name',
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
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    hintText: 'Full Name',
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(16.0,
                                                            20.0, 20.0, 16.0),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.5)),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
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
                                                '3. Marital Status',
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
                                            alignment: const Alignment(0, 0),
                                            children: [
                                              BlocListener(
                                                  bloc: maritalStatusBloc,
                                                  listener: (_,
                                                      MaritalStatusState
                                                          state) {
                                                    if (state
                                                        is MaritalStatusLoading) {}
                                                    if (state
                                                        is MaritalStatusLoaded) {
                                                      setState(() {
                                                        selectIndexMaritalStatus =
                                                            1000;
                                                      });
                                                    }

                                                    if (state
                                                        is MaritalStatusError) {}
                                                    if (state
                                                        is MaritalStatusException) {}
                                                  },
                                                  child: BlocBuilder(
                                                      bloc: maritalStatusBloc,
                                                      builder: (_,
                                                          MaritalStatusState
                                                              state) {
                                                        if (state
                                                            is MaritalStatusLoading) {}
                                                        if (state
                                                            is MaritalStatusLoaded) {
                                                          return InkWell(
                                                            onTap: () {
                                                              _showBottomMaritalStatus(
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
                                                                color: Colors
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
                                                                  selectMaritalStatus ==
                                                                          ''
                                                                      ? 'Select Marital Status'
                                                                      : selectMaritalStatus,
                                                                  style: TextStyle(
                                                                      color: selectMaritalStatus == ''
                                                                          ? Colors.grey.withOpacity(
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
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1)),
                                                            color: Colors.white,
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
                                              Positioned(
                                                right: 16,
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: const Icon(
                                                    Icons.search_rounded,
                                                    color: Color(0xFF3D3D3D),
                                                  ),
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
                                                '4. Place of Birth',
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
                                                controller: ctrlPob,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    hintText: 'Place of Birth',
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(16.0,
                                                            20.0, 20.0, 16.0),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.5)),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
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
                                                '5. Date of Birth',
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
                                                controller: ctrlDate,
                                                onTap: dateOb == 0
                                                    ? null
                                                    : _presentDatePicker,
                                                keyboardType:
                                                    TextInputType.text,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                    hintText: 'Date of Birth',
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(16.0,
                                                            20.0, 20.0, 16.0),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.5)),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
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
                                      MediaQuery.of(context).size.width * 0.23,
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
                                                '6. Gender',
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
                                                  onTap: () {
                                                    setState(() {
                                                      gender = 'Male';
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration: BoxDecoration(
                                                      color: gender == 'Male'
                                                          ? primaryColor
                                                          : const Color(
                                                              0xFFE1E1E1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Center(
                                                        child: Text('Male',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600))),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      gender = 'Female';
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration: BoxDecoration(
                                                      color: gender == 'Female'
                                                          ? primaryColor
                                                          : const Color(
                                                              0xFFE1E1E1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Center(
                                                        child: Text('Female',
                                                            style: TextStyle(
                                                                fontSize: 15,
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
                                            children: const [
                                              Text(
                                                '7. Mother Maiden Name',
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
                                                controller: ctrlMotherName,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'Mother Maiden Name',
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(16.0,
                                                            20.0, 20.0, 16.0),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.5)),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
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
                                                '8. Email',
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
                                          Form(
                                            key: formKey,
                                            child: Material(
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
                                                width: 280,
                                                height: 50,
                                                child: TextFormField(
                                                  controller: ctrlEmail,
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            "[0-9@a-zA-Z.]")),
                                                  ],
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      hintText: 'Email',
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
                                                '9. Phone No',
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
                                                          BorderRadius.circular(
                                                              10),
                                                      side: const BorderSide(
                                                          width: 1.0,
                                                          color: Color(
                                                              0xFFEAEAEA))),
                                                  child: SizedBox(
                                                    width: 90,
                                                    height: 50,
                                                    child: TextFormField(
                                                      controller: ctrlPhoneCode,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            4),
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                              hintText: 'Code',
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
                                                    width: 180,
                                                    height: 50,
                                                    child: TextFormField(
                                                      controller:
                                                          ctrlPhoneNumber,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            15),
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Phone Number',
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
                                                '10. Spouse Name',
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
                                                controller: ctrlSpouseName,
                                                readOnly: selectMaritalStatus ==
                                                            'SINGLE' ||
                                                        selectMaritalStatus ==
                                                            'WIDOW'
                                                    ? true
                                                    : false,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    hintText: 'Spouse Name',
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(16.0,
                                                            20.0, 20.0, 16.0),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.5)),
                                                    filled: true,
                                                    fillColor: selectMaritalStatus ==
                                                                'SINGLE' ||
                                                            selectMaritalStatus ==
                                                                'WIDOW'
                                                        ? const Color(
                                                            0xFFFAF9F9)
                                                        : Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
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
                                      MediaQuery.of(context).size.width * 0.23,
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
                                                '11. Spouse ID',
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
                                                controller: ctrlSpouseId,
                                                readOnly: selectMaritalStatus ==
                                                            'SINGLE' ||
                                                        selectMaritalStatus ==
                                                            'WIDOW'
                                                    ? true
                                                    : false,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      16),
                                                ],
                                                decoration: InputDecoration(
                                                    hintText: 'Spouse ID',
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(16.0,
                                                            20.0, 20.0, 16.0),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.5)),
                                                    filled: true,
                                                    fillColor: selectMaritalStatus ==
                                                                'SINGLE' ||
                                                            selectMaritalStatus ==
                                                                'WIDOW'
                                                        ? const Color(
                                                            0xFFFAF9F9)
                                                        : Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
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
                                                '12. Province',
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
                                            alignment: const Alignment(0, 0),
                                            children: [
                                              BlocListener(
                                                  bloc: provBloc,
                                                  listener:
                                                      (_, ProvState state) {
                                                    if (state is ProvLoading) {}
                                                    if (state is ProvLoaded) {
                                                      setState(() {
                                                        selectIndexProv = 1000;
                                                      });
                                                    }

                                                    if (state is ProvError) {}
                                                    if (state
                                                        is ProvException) {}
                                                  },
                                                  child: BlocBuilder(
                                                      bloc: provBloc,
                                                      builder:
                                                          (_, ProvState state) {
                                                        if (state
                                                            is ProvLoading) {}
                                                        if (state
                                                            is ProvLoaded) {
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
                                                                color: Colors
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
                                                                  selectProv ==
                                                                          ''
                                                                      ? 'Select Province'
                                                                      : selectProv,
                                                                  style: TextStyle(
                                                                      color: selectProv == ''
                                                                          ? Colors.grey.withOpacity(
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
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1)),
                                                            color: Colors.white,
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
                                                '13. City',
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
                                            alignment: const Alignment(0, 0),
                                            children: [
                                              BlocListener(
                                                  bloc: cityBloc,
                                                  listener:
                                                      (_, CityState state) {
                                                    if (state is CityLoading) {}
                                                    if (state is CityLoaded) {
                                                      setState(() {
                                                        selectIndexCity = 1000;
                                                      });
                                                    }
                                                    if (state is CityError) {}
                                                    if (state
                                                        is CityException) {}
                                                  },
                                                  child: BlocBuilder(
                                                      bloc: cityBloc,
                                                      builder:
                                                          (_, CityState state) {
                                                        if (state
                                                            is CityLoading) {}
                                                        if (state
                                                            is CityLoaded) {
                                                          return InkWell(
                                                            onTap: () {
                                                              _showBottomCity(state
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
                                                                color: Colors
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
                                                                  selectCity ==
                                                                          ''
                                                                      ? 'Select City'
                                                                      : selectCity,
                                                                  style: TextStyle(
                                                                      color: selectCity == ''
                                                                          ? Colors.grey.withOpacity(
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
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1)),
                                                            color: Colors.white,
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
                                                '14. Zipcode',
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
                                            alignment: const Alignment(0, 0),
                                            children: [
                                              BlocListener(
                                                  bloc: zipCodeBloc,
                                                  listener:
                                                      (_, ZipCodeState state) {
                                                    if (state
                                                        is ZipCodeLoading) {}
                                                    if (state
                                                        is ZipCodeLoaded) {
                                                      setState(() {
                                                        selectIndexPostal =
                                                            1000;
                                                      });
                                                    }

                                                    if (state
                                                        is ZipCodeError) {}
                                                    if (state
                                                        is ZipCodeException) {}
                                                  },
                                                  child: BlocBuilder(
                                                      bloc: zipCodeBloc,
                                                      builder: (_,
                                                          ZipCodeState state) {
                                                        if (state
                                                            is ZipCodeLoading) {}
                                                        if (state
                                                            is ZipCodeLoaded) {
                                                          return InkWell(
                                                              onTap: () {
                                                                _showBottomPostal(
                                                                    state
                                                                        .zipCodeResponseModel);
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
                                                                  color: Colors
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
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 16.0,
                                                                    right:
                                                                        16.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    selectPostal ==
                                                                            ''
                                                                        ? 'Select Zipcode'
                                                                        : selectPostal,
                                                                    style: TextStyle(
                                                                        color: selectPostal ==
                                                                                ''
                                                                            ? Colors.grey.withOpacity(
                                                                                0.5)
                                                                            : Colors
                                                                                .black,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                              ));
                                                        }

                                                        return Container(
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
                                                            color: Colors.white,
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
                                                '15. Sub District',
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
                                                controller: ctrlSubDistrict,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    hintText: 'Sub District',
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(16.0,
                                                            20.0, 20.0, 16.0),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.5)),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
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
                                      MediaQuery.of(context).size.width * 0.23,
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
                                                '16. Village',
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
                                                controller: ctrlSubVillage,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    hintText: 'Village',
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(16.0,
                                                            20.0, 20.0, 16.0),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.5)),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
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
                                                '17. Address',
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
                                              height: 151,
                                              child: TextFormField(
                                                controller: ctrlAddress,
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLines: 6,
                                                decoration: InputDecoration(
                                                    hintText: 'Address',
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(16.0,
                                                            20.0, 20.0, 16.0),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.5)),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
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
                                                '18. RT / RW',
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
                                                          BorderRadius.circular(
                                                              10),
                                                      side: const BorderSide(
                                                          width: 1.0,
                                                          color: Color(
                                                              0xFFEAEAEA))),
                                                  child: SizedBox(
                                                    width: 130,
                                                    height: 50,
                                                    child: TextFormField(
                                                      controller: ctrlRt,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                              hintText: 'RT',
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
                                                    width: 130,
                                                    height: 50,
                                                    child: TextFormField(
                                                      controller: ctrlRw,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                              hintText: 'RW',
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
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: const [
                                              SizedBox(
                                                width: 140,
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Text(
                                                'Status',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          BlocListener(
                                              bloc: checkScoringBloc,
                                              listener:
                                                  (_, CheckScoringState state) {
                                                if (state
                                                    is CheckScoringLoading) {}
                                                if (state
                                                    is CheckScoringLoaded) {
                                                  setState(() {
                                                    ctrlStatus.text = state
                                                        .checkScoringResponseModel
                                                        .message!;
                                                  });
                                                }
                                                if (state
                                                    is CheckScoringError) {}
                                                if (state
                                                    is CheckScoringException) {}
                                              },
                                              child: BlocBuilder(
                                                  bloc: checkScoringBloc,
                                                  builder: (_,
                                                      CheckScoringState state) {
                                                    if (state
                                                        is CheckScoringLoading) {
                                                      return Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 130,
                                                            height: 50,
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Material(
                                                            elevation: 6,
                                                            shadowColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.4),
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
                                                              width: 140,
                                                              height: 50,
                                                              child:
                                                                  TextFormField(
                                                                readOnly: true,
                                                                controller:
                                                                    ctrlStatus,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                decoration:
                                                                    InputDecoration(
                                                                        hintText:
                                                                            '-',
                                                                        isDense:
                                                                            true,
                                                                        contentPadding: const EdgeInsets.fromLTRB(
                                                                            16.0,
                                                                            20.0,
                                                                            20.0,
                                                                            16.0),
                                                                        hintStyle: TextStyle(
                                                                            color: Colors.grey.withOpacity(
                                                                                0.5)),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors
                                                                                .white,
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          borderSide:
                                                                              BorderSide.none,
                                                                        )),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    if (state
                                                        is CheckScoringLoaded) {
                                                      return Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              checkScoringBloc.add(
                                                                  const CheckScoringAttempt(
                                                                      'PASS'));
                                                            },
                                                            child: Container(
                                                              width: 130,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: const Center(
                                                                  child: Text(
                                                                      'Check Scoring',
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
                                                          Material(
                                                            elevation: 6,
                                                            shadowColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.4),
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
                                                              width: 140,
                                                              height: 50,
                                                              child:
                                                                  TextFormField(
                                                                readOnly: true,
                                                                controller:
                                                                    ctrlStatus,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                decoration:
                                                                    InputDecoration(
                                                                        hintText:
                                                                            '-',
                                                                        isDense:
                                                                            true,
                                                                        contentPadding: const EdgeInsets.fromLTRB(
                                                                            16.0,
                                                                            20.0,
                                                                            20.0,
                                                                            16.0),
                                                                        hintStyle: TextStyle(
                                                                            color: Colors.grey.withOpacity(
                                                                                0.5)),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors
                                                                                .white,
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          borderSide:
                                                                              BorderSide.none,
                                                                        )),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            checkScoringBloc.add(
                                                                const CheckScoringAttempt(
                                                                    'PASS'));
                                                          },
                                                          child: Container(
                                                            width: 130,
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  primaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: const Center(
                                                                child: Text(
                                                                    'Check Scoring',
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
                                                        Material(
                                                          elevation: 6,
                                                          shadowColor: Colors
                                                              .grey
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
                                                            width: 140,
                                                            height: 50,
                                                            child:
                                                                TextFormField(
                                                              readOnly: true,
                                                              controller:
                                                                  ctrlStatus,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          '-',
                                                                      isDense:
                                                                          true,
                                                                      contentPadding: const EdgeInsets
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
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .white,
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        borderSide:
                                                                            BorderSide.none,
                                                                      )),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  })),
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
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
                    InkWell(
                      onTap: ctrlStatus.text.isEmpty ||
                              ctrlStatus.text == 'NOT PASS'
                          ? null
                          : () {
                              if (GeneralUtil.regexes
                                  .hasMatch(ctrlEmail.text)) {
                                if (selectMaritalStatus != '') {
                                  if (selectMaritalStatus == 'SINGLE' ||
                                      selectMaritalStatus == 'WIDOW') {
                                    if (ctrlDate.text.isEmpty ||
                                        ctrlDate.text == '' ||
                                        ctrlIdNo.text.isEmpty ||
                                        ctrlIdNo.text == '' ||
                                        ctrlFullName.text.isEmpty ||
                                        ctrlFullName.text == '' ||
                                        ctrlPob.text.isEmpty ||
                                        ctrlPob.text == '' ||
                                        ctrlMotherName.text.isEmpty ||
                                        ctrlMotherName.text == '' ||
                                        ctrlEmail.text.isEmpty ||
                                        ctrlEmail.text == '' ||
                                        ctrlPhoneCode.text.isEmpty ||
                                        ctrlPhoneCode.text == '' ||
                                        ctrlPhoneNumber.text.isEmpty ||
                                        ctrlPhoneNumber.text == '' ||
                                        ctrlSubDistrict.text.isEmpty ||
                                        ctrlSubDistrict.text == '' ||
                                        ctrlSubVillage.text.isEmpty ||
                                        ctrlSubVillage.text == '' ||
                                        ctrlAddress.text.isEmpty ||
                                        ctrlAddress.text == '' ||
                                        ctrlRt.text.isEmpty ||
                                        ctrlRt.text == '' ||
                                        ctrlRw.text.isEmpty ||
                                        ctrlRw.text == '' ||
                                        selectProv == '' ||
                                        selectCity == '' ||
                                        selectPostal == '' ||
                                        selectPostal == '') {
                                      EmptyWidget().showBottomEmpty(context);
                                    } else {
                                      clientDetailResponseModel.applicationNo =
                                          widget.applicationNo;
                                      clientDetailResponseModel.clientIdNo =
                                          ctrlIdNo.text;
                                      clientDetailResponseModel.clientFullName =
                                          ctrlFullName.text;
                                      clientDetailResponseModel
                                              .clientMotherMaidenName =
                                          ctrlMotherName.text;
                                      clientDetailResponseModel
                                          .clientPlaceOfBirth = ctrlPob.text;
                                      clientDetailResponseModel
                                          .clientDateOfBirth = dateSend;
                                      clientDetailResponseModel
                                              .clientGenderCode =
                                          gender == 'Male' ? 'M' : 'F';
                                      clientDetailResponseModel
                                          .clientGenderType = gender;
                                      clientDetailResponseModel
                                              .clientMaritalStatusCode =
                                          selectMaritalStatus;
                                      clientDetailResponseModel
                                              .clientMaritalStatusType =
                                          selectMaritalStatus;
                                      clientDetailResponseModel.clientEmail =
                                          ctrlEmail.text;
                                      clientDetailResponseModel
                                              .clientAreaMobileNo =
                                          ctrlPhoneCode.text;
                                      clientDetailResponseModel.clientMobileNo =
                                          ctrlPhoneNumber.text;
                                      clientDetailResponseModel
                                              .clientSpouseName =
                                          ctrlSpouseName.text;
                                      clientDetailResponseModel
                                          .clientSpouseIdNo = ctrlSpouseId.text;
                                      clientDetailResponseModel
                                          .addressProvinceCode = selectProvCode;
                                      clientDetailResponseModel
                                          .addressProvinceName = selectProv;
                                      clientDetailResponseModel
                                          .addressCityCode = selectCityCode;
                                      clientDetailResponseModel
                                          .addressCityName = selectCity;
                                      clientDetailResponseModel.addressZipCode =
                                          selectPostalCode;
                                      clientDetailResponseModel
                                              .addressZipCodeCode =
                                          selectPostalCode;
                                      clientDetailResponseModel.addressZipName =
                                          selectPostal;
                                      clientDetailResponseModel
                                              .addressSubDistrict =
                                          ctrlSubDistrict.text;
                                      clientDetailResponseModel.addressVillage =
                                          ctrlSubVillage.text;
                                      clientDetailResponseModel.addressAddress =
                                          ctrlAddress.text;
                                      clientDetailResponseModel.addressRt =
                                          ctrlRt.text;
                                      clientDetailResponseModel.addressRw =
                                          ctrlRw.text;

                                      Navigator.pushNamed(
                                          context,
                                          StringRouterUtil
                                              .applicationForm2UseScreenTabRoute,
                                          arguments: clientDetailResponseModel);
                                    }
                                  } else {
                                    if (ctrlDate.text.isEmpty ||
                                        ctrlDate.text == '' ||
                                        ctrlIdNo.text.isEmpty ||
                                        ctrlIdNo.text == '' ||
                                        ctrlFullName.text.isEmpty ||
                                        ctrlFullName.text == '' ||
                                        ctrlPob.text.isEmpty ||
                                        ctrlPob.text == '' ||
                                        ctrlMotherName.text.isEmpty ||
                                        ctrlMotherName.text == '' ||
                                        ctrlEmail.text.isEmpty ||
                                        ctrlEmail.text == '' ||
                                        ctrlPhoneCode.text.isEmpty ||
                                        ctrlPhoneCode.text == '' ||
                                        ctrlPhoneNumber.text.isEmpty ||
                                        ctrlPhoneNumber.text == '' ||
                                        ctrlSpouseName.text.isEmpty ||
                                        ctrlSpouseName.text == '' ||
                                        ctrlSpouseId.text.isEmpty ||
                                        ctrlSpouseId.text == '' ||
                                        ctrlSubDistrict.text.isEmpty ||
                                        ctrlSubDistrict.text == '' ||
                                        ctrlSubVillage.text.isEmpty ||
                                        ctrlSubVillage.text == '' ||
                                        ctrlAddress.text.isEmpty ||
                                        ctrlAddress.text == '' ||
                                        ctrlRt.text.isEmpty ||
                                        ctrlRt.text == '' ||
                                        ctrlRw.text.isEmpty ||
                                        ctrlRw.text == '' ||
                                        selectProv == '' ||
                                        selectCity == '' ||
                                        selectPostal == '' ||
                                        selectPostal == '') {
                                      EmptyWidget().showBottomEmpty(context);
                                    } else {
                                      clientDetailResponseModel.clientIdNo =
                                          ctrlIdNo.text;
                                      clientDetailResponseModel.clientFullName =
                                          ctrlFullName.text;
                                      clientDetailResponseModel
                                              .clientMotherMaidenName =
                                          ctrlMotherName.text;
                                      clientDetailResponseModel
                                          .clientPlaceOfBirth = ctrlPob.text;
                                      clientDetailResponseModel
                                          .clientDateOfBirth = dateSend;
                                      clientDetailResponseModel
                                              .clientGenderCode =
                                          gender == 'Male' ? 'M' : 'F';
                                      clientDetailResponseModel
                                          .clientGenderType = gender;
                                      clientDetailResponseModel
                                              .clientMaritalStatusCode =
                                          selectMaritalStatus;
                                      clientDetailResponseModel
                                              .clientMaritalStatusType =
                                          selectMaritalStatus;
                                      clientDetailResponseModel.clientEmail =
                                          ctrlEmail.text;
                                      clientDetailResponseModel
                                              .clientAreaMobileNo =
                                          ctrlPhoneCode.text;
                                      clientDetailResponseModel.clientMobileNo =
                                          ctrlPhoneNumber.text;
                                      clientDetailResponseModel
                                              .clientSpouseName =
                                          ctrlSpouseName.text;
                                      clientDetailResponseModel
                                          .clientSpouseIdNo = ctrlSpouseId.text;
                                      clientDetailResponseModel
                                          .addressProvinceCode = selectProvCode;
                                      clientDetailResponseModel
                                          .addressProvinceName = selectProv;
                                      clientDetailResponseModel
                                          .addressCityCode = selectCityCode;
                                      clientDetailResponseModel
                                          .addressCityName = selectCity;
                                      clientDetailResponseModel.addressZipCode =
                                          selectPostalCode;
                                      clientDetailResponseModel
                                              .addressZipCodeCode =
                                          selectPostalCode;
                                      clientDetailResponseModel.addressZipName =
                                          selectPostal;
                                      clientDetailResponseModel
                                              .addressSubDistrict =
                                          ctrlSubDistrict.text;
                                      clientDetailResponseModel.addressVillage =
                                          ctrlSubVillage.text;
                                      clientDetailResponseModel.addressAddress =
                                          ctrlAddress.text;
                                      clientDetailResponseModel.addressRt =
                                          ctrlRt.text;
                                      clientDetailResponseModel.addressRw =
                                          ctrlRw.text;

                                      Navigator.pushNamed(
                                          context,
                                          StringRouterUtil
                                              .applicationForm2UseScreenTabRoute,
                                          arguments: clientDetailResponseModel);
                                    }
                                  }
                                } else {
                                  EmptyWidget().showBottomEmpty(context);
                                }
                              } else {
                                WrongWidget().showBottomEmpty(context);
                              }
                            },
                      child: Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: ctrlStatus.text.isEmpty ||
                                  ctrlStatus.text == 'NOT PASS'
                              ? const Color(0xFFE1E1E1)
                              : thirdColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: Text('NEXT',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: ctrlStatus.text.isEmpty
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ),
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
