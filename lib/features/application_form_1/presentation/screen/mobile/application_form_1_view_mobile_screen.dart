import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_form_1/data/zip_code_response_model.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/check_scoring_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/city_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/get_client_bloc/bloc.dart';
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
import 'package:sales_order/features/application_form_1/data/client_detail_response_model.dart'
    as cd;
import 'package:shimmer/shimmer.dart';

class ApplicationForm1ViewMobileScreen extends StatefulWidget {
  const ApplicationForm1ViewMobileScreen(
      {super.key, required this.applicationNo});
  final String applicationNo;

  @override
  State<ApplicationForm1ViewMobileScreen> createState() =>
      _ApplicationForm1ViewMobileScreenState();
}

class _ApplicationForm1ViewMobileScreenState
    extends State<ApplicationForm1ViewMobileScreen> {
  bool isLoading = true;
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
  GetClientBloc getClientBloc = GetClientBloc(form1repo: Form1Repo());
  cd.Data clientDetailResponseModel = cd.Data();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getClientBloc.add(GetClientAttempt(widget.applicationNo));
    super.initState();
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
                    ],
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
        body: MultiBlocListener(
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
                        DateTime tempPromDate = DateFormat('yyyy-MM-dd').parse(
                            state.clientDetailResponseModel.data![0]
                                .clientDateOfBirth!);
                        var inputPromDate =
                            DateTime.parse(tempPromDate.toString());
                        var outputPromFormat = DateFormat('dd MMMM yyyy');
                        dateSend =
                            DateFormat('yyyy-MM-dd').format(tempPromDate);
                        ctrlDate.text = outputPromFormat.format(inputPromDate);
                      }
                      if (state.clientDetailResponseModel.data![0].clientIdNo !=
                          null) {
                        ctrlIdNo.text = state
                            .clientDetailResponseModel.data![0].clientIdNo!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .clientFullName !=
                          null) {
                        ctrlFullName.text = state
                            .clientDetailResponseModel.data![0].clientFullName!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .clientPlaceOfBirth !=
                          null) {
                        ctrlPob.text = state.clientDetailResponseModel.data![0]
                            .clientPlaceOfBirth!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .clientMotherMaidenName !=
                          null) {
                        ctrlMotherName.text = state.clientDetailResponseModel
                            .data![0].clientMotherMaidenName!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .clientGenderType !=
                          null) {
                        gender = state.clientDetailResponseModel.data![0]
                                    .clientGenderType!
                                    .toUpperCase() ==
                                'M'
                            ? 'MALE'
                            : 'FEMALE';
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .clientMaritalStatusType !=
                          null) {
                        selectMaritalStatus = state.clientDetailResponseModel
                            .data![0].clientMaritalStatusType!;
                      }
                      if (state
                              .clientDetailResponseModel.data![0].clientEmail !=
                          null) {
                        ctrlEmail.text = state
                            .clientDetailResponseModel.data![0].clientEmail!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .clientAreaMobileNo !=
                          null) {
                        ctrlPhoneCode.text = state.clientDetailResponseModel
                            .data![0].clientAreaMobileNo!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .clientMobileNo !=
                          null) {
                        ctrlPhoneNumber.text = state
                            .clientDetailResponseModel.data![0].clientMobileNo!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .clientSpouseName !=
                          null) {
                        ctrlSpouseName.text = state.clientDetailResponseModel
                            .data![0].clientSpouseName!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .clientSpouseIdNo !=
                          null) {
                        ctrlSpouseId.text = state.clientDetailResponseModel
                            .data![0].clientSpouseIdNo!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .addressProvinceCode !=
                          null) {
                        selectProv = state.clientDetailResponseModel.data![0]
                            .addressProvinceName!;
                        selectProvCode = state.clientDetailResponseModel
                            .data![0].addressProvinceCode!;
                        cityBloc.add(CityAttempt(selectProvCode));
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .addressCityName !=
                          null) {
                        selectCity = state.clientDetailResponseModel.data![0]
                            .addressCityName!;
                        selectCityCode = state.clientDetailResponseModel
                            .data![0].addressCityCode!;
                        zipCodeBloc.add(ZipCodeAttempt(selectCityCode));
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .addressZipName !=
                          null) {
                        selectPostal = state
                            .clientDetailResponseModel.data![0].addressZipCode!;
                        selectPostalName = state
                            .clientDetailResponseModel.data![0].addressZipName!;
                        selectPostalCode = state.clientDetailResponseModel
                            .data![0].addressZipCodeCode!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .addressSubDistrict !=
                          null) {
                        ctrlSubDistrict.text = state.clientDetailResponseModel
                            .data![0].addressSubDistrict!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .addressVillage !=
                          null) {
                        ctrlSubVillage.text = state
                            .clientDetailResponseModel.data![0].addressVillage!;
                      }
                      if (state.clientDetailResponseModel.data![0]
                              .addressAddress !=
                          null) {
                        ctrlAddress.text = state
                            .clientDetailResponseModel.data![0].addressAddress!;
                      }
                      if (state.clientDetailResponseModel.data![0].addressRt !=
                          null) {
                        ctrlRt.text =
                            state.clientDetailResponseModel.data![0].addressRt!;
                      }
                      if (state.clientDetailResponseModel.data![0].addressRw !=
                          null) {
                        ctrlRw.text =
                            state.clientDetailResponseModel.data![0].addressRw!;
                      }
                      isLoading = false;
                    });
                    maritalStatusBloc.add(const MaritalStatusAttempt('MRTYP'));
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
                : SingleChildScrollView(
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'ID NO',
                                        isDense: true,
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Full Name',
                                        isDense: true,
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
                                    selectMaritalStatus,
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
                                    readOnly: true,
                                    controller: ctrlPob,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Place of Birth',
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
                                    keyboardType: TextInputType.text,
                                    readOnly: true,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Date of Birth',
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Mother Maiden Name',
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
                                            child: Text('MALE',
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
                                            child: Text('FEMALE',
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
                              const SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 45,
                                      child: TextFormField(
                                        controller: ctrlEmail,
                                        readOnly: true,
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(
                                            color: Color(0xFF6E6E6E)),
                                        decoration: InputDecoration(
                                            hintText: 'Email',
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
                              const SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                0.3,
                                            height: 45,
                                            child: TextFormField(
                                              controller: ctrlPhoneCode,
                                              readOnly: true,
                                              keyboardType: TextInputType.text,
                                              style: const TextStyle(
                                                  color: Color(0xFF6E6E6E)),
                                              decoration: InputDecoration(
                                                  hintText: 'Code',
                                                  isDense: true,
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor:
                                                      const Color(0xFFFAF9F9),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  )),
                                            ),
                                          ),
                                        ),
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
                                              readOnly: true,
                                              controller: ctrlPhoneNumber,
                                              keyboardType: TextInputType.text,
                                              style: const TextStyle(
                                                  color: Color(0xFF6E6E6E)),
                                              decoration: InputDecoration(
                                                  hintText: 'Phone Number',
                                                  isDense: true,
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor:
                                                      const Color(0xFFFAF9F9),
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Spouse Name',
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Spouse ID No',
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                16.0, 20.0, 20.0, 16.0),
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
                                    selectProv,
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
                                    '13. City',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
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
                                    selectCity,
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
                                    '14. Zipcode',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
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
                                    selectPostal,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
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
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Sub District',
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
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Village',
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
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    maxLines: 6,
                                    decoration: InputDecoration(
                                        hintText: 'Address',
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: const BorderSide(
                                              width: 1.0,
                                              color: Color(0xFFEAEAEA))),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height: 45,
                                        child: TextFormField(
                                          controller: ctrlRt,
                                          readOnly: true,
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                              color: Color(0xFF6E6E6E)),
                                          decoration: InputDecoration(
                                              hintText: 'RT',
                                              isDense: true,
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
                                    const SizedBox(width: 8),
                                    Material(
                                      elevation: 6,
                                      shadowColor: Colors.grey.withOpacity(0.4),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: const BorderSide(
                                              width: 1.0,
                                              color: Color(0xFFEAEAEA))),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height: 45,
                                        child: TextFormField(
                                          controller: ctrlRw,
                                          readOnly: true,
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                              color: Color(0xFF6E6E6E)),
                                          decoration: InputDecoration(
                                              hintText: 'RW',
                                              isDense: true,
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
                                  ],
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
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
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
                                            .applicationForm2ViewScreenMobileRoute,
                                        arguments: clientDetailResponseModel);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
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
