import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_4/domain/repo/form_4_repo.dart';
import 'package:sales_order/features/application_form_4/presentation/bloc/asset_data_detail_bloc/bloc.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class ApplicationForm4ViewMobileScreen extends StatefulWidget {
  const ApplicationForm4ViewMobileScreen(
      {super.key, required this.applicationNo});
  final String applicationNo;

  @override
  State<ApplicationForm4ViewMobileScreen> createState() =>
      _ApplicationForm4ViewMobileScreenState();
}

class _ApplicationForm4ViewMobileScreenState
    extends State<ApplicationForm4ViewMobileScreen> {
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
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 24, top: 16, bottom: 8),
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
          'Application Form',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocListener(
          bloc: assetDataDetailBloc,
          listener: (_, AssetDataDetailState state) {
            if (state is AssetDataDetailLoading) {}
            if (state is AssetDataDetailLoaded) {
              setState(() {
                if (state.assetDetailResponseModel.data![0].vehicleMerkCode !=
                    null) {
                  selectMerkCode =
                      state.assetDetailResponseModel.data![0].vehicleMerkCode!;
                  selectMerk =
                      state.assetDetailResponseModel.data![0].vehicleMerkDesc!;
                }
                if (state.assetDetailResponseModel.data![0].vehicleModelCode !=
                    null) {
                  selectModelCode =
                      state.assetDetailResponseModel.data![0].vehicleModelCode!;
                  selectModel =
                      state.assetDetailResponseModel.data![0].vehicleModelDesc!;
                }
                if (state.assetDetailResponseModel.data![0].vehicleTypeCode !=
                    null) {
                  selectTypeCode =
                      state.assetDetailResponseModel.data![0].vehicleTypeCode!;
                  selectType =
                      state.assetDetailResponseModel.data![0].vehicleTypeDesc!;
                }
                if (state.assetDetailResponseModel.data![0].assetCondition !=
                    null) {
                  condition =
                      state.assetDetailResponseModel.data![0].assetCondition! ==
                              'NEW'
                          ? 'New'
                          : 'Used';
                }

                if (state.assetDetailResponseModel.data![0].assetAmount !=
                    null) {
                  ctrlAmount.text = GeneralUtil.convertToIdr(
                      state.assetDetailResponseModel.data![0].assetAmount!, 2);
                }
                if (state.assetDetailResponseModel.data![0].colour != null) {
                  ctrlColor.text =
                      state.assetDetailResponseModel.data![0].colour!;
                }
                if (state.assetDetailResponseModel.data![0].assetYear != null ||
                    state.assetDetailResponseModel.data![0].assetYear != "") {
                  ctrlYear.text =
                      state.assetDetailResponseModel.data![0].assetYear!;
                }
                if (state.assetDetailResponseModel.data![0].chassisNo != null) {
                  ctrlChasisNo.text =
                      state.assetDetailResponseModel.data![0].chassisNo!;
                }
                if (state.assetDetailResponseModel.data![0].engineNo != null) {
                  ctrlEngineNo.text =
                      state.assetDetailResponseModel.data![0].engineNo!;
                }
                if (state.assetDetailResponseModel.data![0].platNo1 != null) {
                  ctrlPlatNo1.text =
                      state.assetDetailResponseModel.data![0].platNo1!;
                  ctrlPlatNo2.text =
                      state.assetDetailResponseModel.data![0].platNo2!;
                  ctrlPlatNo3.text =
                      state.assetDetailResponseModel.data![0].platNo3!;
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
                  return SingleChildScrollView(
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
                                    '1. Merk',
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
                                    selectMerk,
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
                                    '2. Model',
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
                                    selectModel,
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
                                    '3. Type',
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
                                    selectType,
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
                                    '4. Asset Amount',
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
                                    controller: ctrlAmount,
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        prefix: Padding(
                                          padding: const EdgeInsets.only(
                                              right:
                                                  4.0), // Adjust the padding as needed
                                          child: Text(GeneralUtil
                                              .currency), // Your prefix text here
                                        ),
                                        hintText: 'Asset Amount',
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
                                    '5. Condition',
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
                                          color: condition == 'New'
                                              ? primaryColor
                                              : const Color(0xFFE1E1E1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                            child: Text('New',
                                                style: TextStyle(
                                                    fontSize: 15,
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
                                          color: condition == 'Used'
                                              ? primaryColor
                                              : const Color(0xFFE1E1E1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                            child: Text('Used',
                                                style: TextStyle(
                                                    fontSize: 15,
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
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    '6. Colour',
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
                                    controller: ctrlColor,
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Colour',
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
                                    '7. Asset Year',
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  height: 45,
                                  child: TextFormField(
                                    controller: ctrlYear,
                                    readOnly: true,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Asset Year',
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
                                    '8. Chasis No',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  condition == 'New'
                                      ? Container()
                                      : const Text(
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
                                    controller: ctrlChasisNo,
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Chasis No',
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
                                    '9. Engine No',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  condition == 'New'
                                      ? Container()
                                      : const Text(
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
                                    controller: ctrlEngineNo,
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Engine No',
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
                                    '10. Plat no',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  condition == 'New'
                                      ? Container()
                                      : const Text(
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
                                width: 280,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        width: 70,
                                        height: 45,
                                        child: TextFormField(
                                          controller: ctrlPlatNo1,
                                          readOnly: true,
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                              color: Color(0xFF6E6E6E)),
                                          decoration: InputDecoration(
                                              hintText: 'B',
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
                                        width: 125,
                                        height: 45,
                                        child: TextFormField(
                                          controller: ctrlPlatNo2,
                                          readOnly: true,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                              color: Color(0xFF6E6E6E)),
                                          decoration: InputDecoration(
                                              hintText: '1234',
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
                                        width: 72,
                                        height: 45,
                                        child: TextFormField(
                                          controller: ctrlPlatNo3,
                                          readOnly: true,
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                              color: Color(0xFF6E6E6E)),
                                          decoration: InputDecoration(
                                              hintText: 'XXX',
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
                                        0.45,
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
                                            .applicationForm5ViewScreenMobileRoute,
                                        arguments: widget.applicationNo);
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
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return _loading();
              })),
    );
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
