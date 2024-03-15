import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_form_1/data/zip_code_response_model.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/check_scoring_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/city_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/marital_status_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/prov_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/zip_code_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/empty_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/wrong_widget.dart';
import 'package:sales_order/features/application_form_2/data/add_client_request_model.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/database_helper.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart'
    as lookup;

class ApplicationForm1MobileScreen extends StatefulWidget {
  const ApplicationForm1MobileScreen({super.key});

  @override
  State<ApplicationForm1MobileScreen> createState() =>
      _ApplicationForm1MobileScreenState();
}

class _ApplicationForm1MobileScreenState
    extends State<ApplicationForm1MobileScreen> {
  String gender = 'MALE';
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

  @override
  void initState() {
    maritalStatusBloc.add(const MaritalStatusAttempt('MRTYP'));
    provBloc.add(const ProvAttempt(''));
    super.initState();
  }

  Future<void> _showBottom(
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
                    maxHeight: MediaQuery.of(context).size.height * 0.7),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, left: 8, right: 8),
                      child: Text(
                        'Province',
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
                            borderRadius: BorderRadius.circular(8),
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
                                    fontSize: 14,
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
                                    ctrlSubDistrict.clear();
                                    ctrlSubVillage.clear();
                                  } else {
                                    cityBloc.add(CityAttempt(tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpMsoResponseModel
                                            .data![index].code!));
                                    selectProv = tempList.isNotEmpty
                                        ? tempList[index].description!
                                        : lookUpMsoResponseModel
                                            .data![index].description!;
                                    selectProvCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpMsoResponseModel
                                            .data![index].code!;
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
                                  selectIndexProv == index
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

  Future<void> _showBottomCity(
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
                        'City',
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
                                    fontSize: 14,
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
                                  if (selectIndexCity == index) {
                                    selectCity = '';
                                    selectCityCode = '';
                                    selectIndexCity = 10000;
                                    selectPostal = '';
                                    selectPostalCode = '';
                                    selectIndexPostal = 10000;
                                    selectPostalName = '';
                                    ctrlSubDistrict.clear();
                                    ctrlSubVillage.clear();
                                  } else {
                                    zipCodeBloc.add(ZipCodeAttempt(
                                        tempList.isNotEmpty
                                            ? tempList[index].code!
                                            : lookUpMsoResponseModel
                                                .data![index].code!));
                                    selectCity = tempList.isNotEmpty
                                        ? tempList[index].description!
                                        : lookUpMsoResponseModel
                                            .data![index].description!;
                                    selectCityCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpMsoResponseModel
                                            .data![index].code!;
                                    selectIndexCity = index;
                                    selectPostal = '';
                                    selectPostalCode = '';
                                    selectIndexPostal = 10000;
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
              ),
            );
          });
        });
  }

  Future<void> _showBottomPostal(ZipCodeResponseModel zipCodeResponseModel) {
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
                      padding: EdgeInsets.only(top: 16.0, left: 8, right: 8),
                      child: Text(
                        'Postal',
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
                                tempList =
                                    zipCodeResponseModel.data!.where((item) {
                                  return item.postalCode!
                                          .toUpperCase()
                                          .contains(value.toUpperCase()) ||
                                      item.zipCodeName!
                                          .toUpperCase()
                                          .contains(value.toUpperCase());
                                }).toList();
                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'Search',
                                isDense: true,
                                contentPadding: const EdgeInsets.all(24),
                                hintStyle: TextStyle(
                                    fontSize: 14,
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
                              : zipCodeResponseModel.data!.length,
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
                                    ctrlSubDistrict.clear();
                                    ctrlSubVillage.clear();
                                    selectIndexPostal = 1000;
                                  } else {
                                    selectPostal = tempList.isNotEmpty
                                        ? tempList[index].postalCode!
                                        : zipCodeResponseModel
                                            .data![index].postalCode!;
                                    selectPostalCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : zipCodeResponseModel
                                            .data![index].code!;
                                    selectPostalName = tempList.isNotEmpty
                                        ? tempList[index].zipCodeName!
                                        : zipCodeResponseModel
                                            .data![index].zipCodeName!;
                                    selectIndexPostal = index;
                                    ctrlSubVillage.text = tempList.isNotEmpty
                                        ? tempList[index].village!
                                        : zipCodeResponseModel
                                            .data![index].village!;
                                    ctrlSubDistrict.text = tempList.isNotEmpty
                                        ? tempList[index].subDistrict!
                                        : zipCodeResponseModel
                                            .data![index].subDistrict!;
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
                                        ? '${tempList[index].postalCode!} - ${tempList[index].subDistrict!} - ${tempList[index].village!}'
                                        : '${zipCodeResponseModel.data![index].postalCode!} - ${zipCodeResponseModel.data![index].subDistrict!} - ${zipCodeResponseModel.data![index].village!}',
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
              ),
            );
          });
        });
  }

  Future<void> _showBottomMaritalStatus(
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
                    'Marital Status',
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
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                child: InkWell(
                  onTap: () {
                    OptionWidget(isUsed: false).showBottomOption(context, '');
                  },
                  child: Row(
                    children: const [
                      SizedBox(width: 8),
                      Icon(
                        Icons.more_vert_rounded,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                    ],),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '1. ID No',
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
                              hintText: 'ID NO',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontSize: 14,
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
                      children: const [
                        Text(
                          '2. Full Name',
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
                          controller: ctrlFullName,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Full Name',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontSize: 14,
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
                          '3. Marital Status',
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
                            bloc: maritalStatusBloc,
                            listener: (_, MaritalStatusState state) {
                              if (state is MaritalStatusLoading) {}
                              if (state is MaritalStatusLoaded) {
                                setState(() {
                                  selectIndexMaritalStatus = 1000;
                                });
                              }

                              if (state is MaritalStatusError) {}
                              if (state is MaritalStatusException) {}
                            },
                            child: BlocBuilder(
                                bloc: maritalStatusBloc,
                                builder: (_, MaritalStatusState state) {
                                  if (state is MaritalStatusLoading) {}
                                  if (state is MaritalStatusLoaded) {
                                    return InkWell(
                                      onTap: () {
                                        _showBottomMaritalStatus(
                                            state.lookUpMsoResponseModel);
                                      },
                                      child: Container(
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
                                            selectMaritalStatus == ''
                                                ? 'Select Marital Status'
                                                : selectMaritalStatus,
                                            style: TextStyle(
                                                color: selectMaritalStatus == ''
                                                    ? Colors.grey
                                                        .withOpacity(0.5)
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Container(
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(0.5),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
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
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '4. Place of Birth',
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
                          controller: ctrlPob,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Place of Birth',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontSize: 14,
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
                          '5. Date of Birth',
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
                          controller: ctrlDate,
                          onTap: _presentDatePicker,
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: 'Date of Birth',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontSize: 14,
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
                      children: const [
                        Text(
                          '6. Mother Maiden Name',
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
                          controller: ctrlMotherName,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Mother Maiden Name',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontSize: 14,
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
                          '7. Gender',
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
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '8. Email',
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
                              controller: ctrlEmail,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9@a-zA-Z.]")),
                              ],
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  isDense: true,
                                  hintStyle: TextStyle(
                                      fontSize: 14,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '9. Phone No',
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
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                elevation: 6,
                                shadowColor: Colors.grey.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        width: 1.0, color: Color(0xFFEAEAEA))),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height: 45,
                                  child: TextFormField(
                                    controller: ctrlPhoneCode,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    decoration: InputDecoration(
                                        hintText: 'Code',
                                        isDense: true,
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        )),
                                  ),
                                ),
                              ),
                              Material(
                                elevation: 6,
                                shadowColor: Colors.grey.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        width: 1.0, color: Color(0xFFEAEAEA))),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 45,
                                  child: TextFormField(
                                    controller: ctrlPhoneNumber,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(15),
                                    ],
                                    decoration: InputDecoration(
                                        hintText: 'Phone Number',
                                        isDense: true,
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        filled: true,
                                        fillColor: Colors.white,
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
                        ),
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
                      children: [
                        const Text(
                          '10. Spouse Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        selectMaritalStatus == 'MARRIED'
                            ? const Text(
                                ' *',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
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
                          controller: ctrlSpouseName,
                          readOnly: selectMaritalStatus == 'SINGLE' ||
                                  selectMaritalStatus == 'WIDOW'
                              ? true
                              : false,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Spouse Name',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: selectMaritalStatus == 'SINGLE' ||
                                      selectMaritalStatus == 'WIDOW'
                                  ? const Color(0xFFFAF9F9)
                                  : Colors.white,
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
                      children: [
                        const Text(
                          '11. Spouse ID No',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        selectMaritalStatus == 'MARRIED'
                            ? const Text(
                                ' *',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
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
                          controller: ctrlSpouseId,
                          readOnly: selectMaritalStatus == 'SINGLE' ||
                                  selectMaritalStatus == 'WIDOW'
                              ? true
                              : false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                          ],
                          decoration: InputDecoration(
                              hintText: 'Spouse ID No',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: selectMaritalStatus == 'SINGLE' ||
                                      selectMaritalStatus == 'WIDOW'
                                  ? const Color(0xFFFAF9F9)
                                  : Colors.white,
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
                          '12. Province',
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
                            bloc: provBloc,
                            listener: (_, ProvState state) {
                              if (state is ProvLoading) {}
                              if (state is ProvLoaded) {
                                setState(() {
                                  selectIndexProv = 1000;
                                });
                              }

                              if (state is ProvError) {}
                              if (state is ProvException) {}
                            },
                            child: BlocBuilder(
                                bloc: provBloc,
                                builder: (_, ProvState state) {
                                  if (state is ProvLoading) {}
                                  if (state is ProvLoaded) {
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
                                            selectProv == ''
                                                ? 'Select Province'
                                                : selectProv,
                                            style: TextStyle(
                                                color: selectProv == ''
                                                    ? Colors.grey
                                                        .withOpacity(0.5)
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Container(
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(0.5),
                                            fontSize: 14,
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
                          '13. City',
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
                            bloc: cityBloc,
                            listener: (_, CityState state) {
                              if (state is CityLoading) {}
                              if (state is CityLoaded) {
                                setState(() {
                                  selectIndexCity = 1000;
                                });
                              }
                              if (state is CityError) {}
                              if (state is CityException) {}
                            },
                            child: BlocBuilder(
                                bloc: cityBloc,
                                builder: (_, CityState state) {
                                  if (state is CityLoading) {}
                                  if (state is CityLoaded) {
                                    return InkWell(
                                      onTap: () {
                                        _showBottomCity(
                                            state.lookUpMsoResponseModel);
                                      },
                                      child: Container(
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
                                            selectCity == ''
                                                ? 'Select City'
                                                : selectCity,
                                            style: TextStyle(
                                                color: selectCity == ''
                                                    ? Colors.grey
                                                        .withOpacity(0.5)
                                                    : Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Container(
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(0.5),
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
                          '14. Zipcode',
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
                            bloc: zipCodeBloc,
                            listener: (_, ZipCodeState state) {
                              if (state is ZipCodeLoading) {}
                              if (state is ZipCodeLoaded) {
                                setState(() {
                                  selectIndexPostal = 1000;
                                });
                              }

                              if (state is ZipCodeError) {}
                              if (state is ZipCodeException) {}
                            },
                            child: BlocBuilder(
                                bloc: zipCodeBloc,
                                builder: (_, ZipCodeState state) {
                                  if (state is ZipCodeLoading) {}
                                  if (state is ZipCodeLoaded) {
                                    return InkWell(
                                        onTap: () {
                                          _showBottomPostal(
                                              state.zipCodeResponseModel);
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
                                              selectPostal == ''
                                                  ? 'Select Zipcode'
                                                  : selectPostal,
                                              style: TextStyle(
                                                  color: selectPostal == ''
                                                      ? Colors.grey
                                                          .withOpacity(0.5)
                                                      : Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ));
                                  }

                                  return Container(
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(0.5),
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
                          '15. Sub District',
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
                          controller: ctrlSubDistrict,
                          readOnly: true,
                          style: const TextStyle(color: Color(0xFF6E6E6E)),
                          decoration: InputDecoration(
                              hintText: 'Sub District',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontSize: 14,
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
                          '16. Village',
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
                          controller: ctrlSubVillage,
                          readOnly: true,
                          style: const TextStyle(color: Color(0xFF6E6E6E)),
                          decoration: InputDecoration(
                              hintText: 'Village',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontSize: 14,
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
                          '17. Address',
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
                        height: 135,
                        child: TextFormField(
                          controller: ctrlAddress,
                          keyboardType: TextInputType.text,
                          maxLines: 6,
                          decoration: InputDecoration(
                              hintText: 'Address',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontSize: 14,
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
                          '18. RT / RW',
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
                      width: double.infinity,
                      child: Row(
                        children: [
                          Material(
                            elevation: 6,
                            shadowColor: Colors.grey.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    width: 1.0, color: Color(0xFFEAEAEA))),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: 45,
                              child: TextFormField(
                                controller: ctrlRt,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    hintText: 'RT',
                                    isDense: true,
                                    hintStyle: TextStyle(
                                        fontSize: 14,
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
                          const SizedBox(width: 8),
                          Material(
                            elevation: 6,
                            shadowColor: Colors.grey.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    width: 1.0, color: Color(0xFFEAEAEA))),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: 45,
                              child: TextFormField(
                                controller: ctrlRw,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    hintText: 'RW',
                                    isDense: true,
                                    hintStyle: TextStyle(
                                        fontSize: 14,
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
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    BlocListener(
                        bloc: checkScoringBloc,
                        listener: (_, CheckScoringState state) {
                          if (state is CheckScoringLoading) {}
                          if (state is CheckScoringLoaded) {
                            setState(() {
                              ctrlStatus.text =
                                  state.checkScoringResponseModel.message!;
                            });
                          }
                          if (state is CheckScoringError) {}
                          if (state is CheckScoringException) {}
                        },
                        child: BlocBuilder(
                            bloc: checkScoringBloc,
                            builder: (_, CheckScoringState state) {
                              if (state is CheckScoringLoading) {
                                return const SizedBox(
                                  width: double.infinity,
                                  height: 53,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state is CheckScoringLoaded) {
                                return InkWell(
                                  onTap: () {
                                    checkScoringBloc
                                        .add(const CheckScoringAttempt('PASS'));
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 53,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                        child: Text('Check Scoring',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                );
                              }

                              return InkWell(
                                onTap: () {
                                  checkScoringBloc
                                      .add(const CheckScoringAttempt('PASS'));
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 53,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                      child: Text('Check Scoring',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600))),
                                ),
                              );
                            })),
                  ],
                ),
                const SizedBox(height: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scoring Status',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
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
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          controller: ctrlStatus,
                          decoration: InputDecoration(
                              hintText: '-',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontSize: 14,
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
                const SizedBox(height: 24),
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
                          width: MediaQuery.of(context).size.width * 0.44,
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
                            : () async {
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
                                        final data =
                                            await DatabaseHelper.getUserData();
                                        // ignore: use_build_context_synchronously
                                        Navigator.pushNamed(
                                            context,
                                            StringRouterUtil
                                                .applicationForm2ScreenMobileRoute,
                                            arguments: AddClientRequestModel(
                                                pIdNo: ctrlIdNo.text,
                                                pFullName: ctrlFullName.text,
                                                pBranchCode: data[0]
                                                    ['branch_code'],
                                                pBranchName: data[0]
                                                    ['branch_name'],
                                                pMotherMaidenName:
                                                    ctrlMotherName.text,
                                                pPlaceOfBirth: ctrlPob.text,
                                                pDateOfBirth: dateSend,
                                                pClientType: 'PERSONAL',
                                                pDocumentType: 'KTP',
                                                pClientGenderCode:
                                                    gender == 'MALE'
                                                        ? 'M'
                                                        : 'F',
                                                pClientEmail: ctrlEmail.text,
                                                pClientAreaMobileNo:
                                                    ctrlPhoneCode.text,
                                                pClientMobileNo:
                                                    ctrlPhoneNumber.text,
                                                pClientMaritalStatusCode:
                                                    selectMaritalStatus,
                                                pClientSpouseName:
                                                    ctrlSpouseName.text,
                                                pClientSpouseIdNo:
                                                    ctrlSpouseId.text,
                                                pAddressProvinceName:
                                                    selectProv,
                                                pAddressProvinceCode:
                                                    selectProvCode,
                                                pAddressCityCode:
                                                    selectCityCode,
                                                pAddressCityName: selectCity,
                                                pAddressZipCodeCode:
                                                    selectPostalCode,
                                                pAddressZipName: selectPostalName,
                                                pAddressZipCode: selectPostal,
                                                pAddressSubDistrict: ctrlSubDistrict.text,
                                                pAddressVillage: ctrlSubVillage.text,
                                                pAddressAddress: ctrlAddress.text,
                                                pAddressRt: ctrlRt.text,
                                                pAddressRw: ctrlRw.text,
                                                pMarketingCode: data[0]['uid'],
                                                pMarketingName: data[0]['name']));
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
                                        final data =
                                            await DatabaseHelper.getUserData();
                                        // ignore: use_build_context_synchronously
                                        Navigator.pushNamed(
                                            context,
                                            StringRouterUtil
                                                .applicationForm2ScreenMobileRoute,
                                            arguments: AddClientRequestModel(
                                                pIdNo: ctrlIdNo.text,
                                                pFullName: ctrlFullName.text,
                                                pBranchCode: data[0]
                                                    ['branch_code'],
                                                pBranchName: data[0]
                                                    ['branch_name'],
                                                pMotherMaidenName:
                                                    ctrlMotherName.text,
                                                pPlaceOfBirth: ctrlPob.text,
                                                pDateOfBirth: dateSend,
                                                pClientType: 'PERSONAL',
                                                pDocumentType: 'KTP',
                                                pClientGenderCode:
                                                    gender == 'MALE'
                                                        ? 'M'
                                                        : 'F',
                                                pClientEmail: ctrlEmail.text,
                                                pClientAreaMobileNo:
                                                    ctrlPhoneCode.text,
                                                pClientMobileNo:
                                                    ctrlPhoneNumber.text,
                                                pClientMaritalStatusCode:
                                                    selectMaritalStatus,
                                                pClientSpouseName:
                                                    ctrlSpouseName.text,
                                                pClientSpouseIdNo:
                                                    ctrlSpouseId.text,
                                                pAddressProvinceName:
                                                    selectProv,
                                                pAddressProvinceCode:
                                                    selectProvCode,
                                                pAddressCityCode:
                                                    selectCityCode,
                                                pAddressCityName: selectCity,
                                                pAddressZipCodeCode:
                                                    selectPostalCode,
                                                pAddressZipName: selectPostalName,
                                                pAddressZipCode: selectPostal,
                                                pAddressSubDistrict: ctrlSubDistrict.text,
                                                pAddressVillage: ctrlSubVillage.text,
                                                pAddressAddress: ctrlAddress.text,
                                                pAddressRt: ctrlRt.text,
                                                pAddressRw: ctrlRw.text,
                                                pMarketingCode: data[0]['uid'],
                                                pMarketingName: data[0]['name']));
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
                          width: MediaQuery.of(context).size.width * 0.44,
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
          ),
        ));
  }
}
