import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/cancel_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/empty_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_4/data/look_up_merk_model.dart';
import 'package:sales_order/features/application_form_4/data/update_asset_request_model.dart';
import 'package:sales_order/features/application_form_4/domain/repo/form_4_repo.dart';
import 'package:sales_order/features/application_form_4/presentation/bloc/asset_data_detail_bloc/bloc.dart';
import 'package:sales_order/features/application_form_4/presentation/bloc/check_validity_bloc/bloc.dart';
import 'package:sales_order/features/application_form_4/presentation/bloc/merk_bloc/bloc.dart';
import 'package:sales_order/features/application_form_4/presentation/bloc/model_bloc/bloc.dart';
import 'package:sales_order/features/application_form_4/presentation/bloc/type_bloc/bloc.dart';
import 'package:sales_order/features/application_form_4/presentation/bloc/update_asset_data_bloc/bloc.dart';
import 'package:sales_order/features/application_form_5/data/update_tnc_request_model.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class ApplicationForm4TabScreen extends StatefulWidget {
  const ApplicationForm4TabScreen({super.key, required this.assetRequestModel});
  final UpdateAssetRequestModel assetRequestModel;

  @override
  State<ApplicationForm4TabScreen> createState() =>
      _ApplicationForm4TabScreenState();
}

class _ApplicationForm4TabScreenState extends State<ApplicationForm4TabScreen> {
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
  String assetAmountValue = '';

  AssetDataDetailBloc assetDataDetailBloc =
      AssetDataDetailBloc(form4repo: Form4Repo());
  CheckValidityBloc checkValidityBloc =
      CheckValidityBloc(form4repo: Form4Repo());
  MerkBloc merkBloc = MerkBloc(form4repo: Form4Repo());
  ModelBloc modelBloc = ModelBloc(form4repo: Form4Repo());
  TypeBloc typeBloc = TypeBloc(form4repo: Form4Repo());
  UpdateAssetDataBloc updateAssetDataBloc =
      UpdateAssetDataBloc(form4repo: Form4Repo());

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
    assetDataDetailBloc
        .add(AssetDataDetailAttempt(widget.assetRequestModel.pApplicationNo!));

    super.initState();
  }

  Future<void> _showBottomMerk(LookUpMerkModel lookUpMerkModel) {
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
                      padding: EdgeInsets.only(top: 32.0, left: 24, right: 24),
                      child: Text(
                        'Merk',
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
                            onChanged: (value) {
                              setStates(() {
                                tempList = lookUpMerkModel.data!
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
                              left: 24, right: 24, bottom: 24),
                          itemCount: tempList.isNotEmpty
                              ? tempList.length
                              : lookUpMerkModel.data!.length,
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
                                  if (selectIndexMerk == index) {
                                    selectMerk = '';
                                    selectMerkCode = '';
                                    selectType = '';
                                    selectTypeCode = '';
                                    selectModel = '';
                                    selectModelCode = '';
                                    selectIndexMerk = 10000;
                                    selectIndexModel = 10000;
                                    selectIndexType = 10000;
                                  } else {
                                    selectMerk = tempList.isNotEmpty
                                        ? tempList[index].description!
                                        : lookUpMerkModel
                                            .data![index].description!;
                                    selectMerkCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpMerkModel.data![index].code!;
                                    selectIndexMerk = index;
                                    selectType = '';
                                    selectTypeCode = '';
                                    selectModel = '';
                                    selectModelCode = '';
                                    selectIndexModel = 10000;
                                    selectIndexType = 10000;
                                    modelBloc.add(ModelAttempt(selectMerkCode));
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
                                        : lookUpMerkModel
                                            .data![index].description!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  selectIndexMerk == index
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

  Future<void> _showBottomModel(LookUpMerkModel lookUpMerkModel) {
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
                      padding: EdgeInsets.only(top: 32.0, left: 24, right: 24),
                      child: Text(
                        'Model',
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
                            onChanged: (value) {
                              setStates(() {
                                tempList = lookUpMerkModel.data!
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
                              left: 24, right: 24, bottom: 24),
                          itemCount: tempList.isNotEmpty
                              ? tempList.length
                              : lookUpMerkModel.data!.length,
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
                                  if (selectIndexModel == index) {
                                    selectType = '';
                                    selectTypeCode = '';
                                    selectModel = '';
                                    selectModelCode = '';
                                    selectIndexModel = 10000;
                                    selectIndexType = 10000;
                                  } else {
                                    selectModel = tempList.isNotEmpty
                                        ? tempList[index].description!
                                        : lookUpMerkModel
                                            .data![index].description!;
                                    selectModelCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpMerkModel.data![index].code!;
                                    selectIndexModel = index;
                                    selectType = '';
                                    selectTypeCode = '';
                                    selectIndexType = 10000;
                                    typeBloc.add(TypeAttempt(selectModelCode));
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
                                        : lookUpMerkModel
                                            .data![index].description!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  selectIndexModel == index
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

  Future<void> _showBottomType(LookUpMerkModel lookUpMerkModel) {
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
                      padding: EdgeInsets.only(top: 32.0, left: 24, right: 24),
                      child: Text(
                        'Type',
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
                            onChanged: (value) {
                              setStates(() {
                                tempList = lookUpMerkModel.data!
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
                              left: 24, right: 24, bottom: 24),
                          itemCount: tempList.isNotEmpty
                              ? tempList.length
                              : lookUpMerkModel.data!.length,
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
                                  if (selectIndexType == index) {
                                    selectType = '';
                                    selectTypeCode = '';
                                    selectIndexType = 10000;
                                  } else {
                                    selectType = tempList.isNotEmpty
                                        ? tempList[index].description!
                                        : lookUpMerkModel
                                            .data![index].description!;
                                    selectTypeCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpMerkModel.data![index].code!;
                                    selectIndexType = index;
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
                                        : lookUpMerkModel
                                            .data![index].description!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  selectIndexType == index
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
                    OptionWidget(isUsed: true).showBottomOption(
                        context, widget.assetRequestModel.pApplicationNo!);
                  },
                  child: const Icon(
                    Icons.more_vert_rounded,
                    size: 28,
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
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Center(
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: primaryColor,
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
                                color: primaryColor,
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Center(
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: primaryColor,
                              )
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
                                color: primaryColor,
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
                                color: Color(0xFFDCDCDC),
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
                  child: BlocListener(
                      bloc: assetDataDetailBloc,
                      listener: (_, AssetDataDetailState state) {
                        if (state is AssetDataDetailLoading) {}
                        if (state is AssetDataDetailLoaded) {
                          setState(() {
                            if (state.assetDetailResponseModel.data![0]
                                    .vehicleMerkCode !=
                                null) {
                              selectMerkCode = state.assetDetailResponseModel
                                  .data![0].vehicleMerkCode!;
                              selectMerk = state.assetDetailResponseModel
                                  .data![0].vehicleMerkDesc!;
                            }
                            if (state.assetDetailResponseModel.data![0]
                                    .vehicleModelCode !=
                                null) {
                              selectModelCode = state.assetDetailResponseModel
                                  .data![0].vehicleModelCode!;
                              log(selectModelCode);
                              selectModel = state.assetDetailResponseModel
                                  .data![0].vehicleModelDesc!;
                              log(selectModel);
                            }
                            if (state.assetDetailResponseModel.data![0]
                                    .vehicleTypeCode !=
                                null) {
                              selectTypeCode = state.assetDetailResponseModel
                                  .data![0].vehicleTypeCode!;
                              selectType = state.assetDetailResponseModel
                                  .data![0].vehicleTypeDesc!;
                            }
                            if (state.assetDetailResponseModel.data![0]
                                    .assetCondition !=
                                null) {
                              condition = state.assetDetailResponseModel
                                          .data![0].assetCondition! ==
                                      'NEW'
                                  ? 'New'
                                  : 'Used';
                            }

                            if (state.assetDetailResponseModel.data![0]
                                    .assetAmount !=
                                null) {
                              ctrlAmount.text =
                                  GeneralUtil.convertToIdrNoSymbol(
                                          state.assetDetailResponseModel
                                              .data![0].assetAmount!,
                                          2)
                                      .toString();
                              assetAmountValue = state.assetDetailResponseModel
                                  .data![0].assetAmount!
                                  .toString();
                            }
                            if (state
                                    .assetDetailResponseModel.data![0].colour !=
                                null) {
                              ctrlColor.text = state
                                  .assetDetailResponseModel.data![0].colour!;
                            }
                            if (state.assetDetailResponseModel.data![0]
                                        .assetYear !=
                                    null ||
                                state.assetDetailResponseModel.data![0]
                                        .assetYear !=
                                    "") {
                              ctrlYear.text = state
                                  .assetDetailResponseModel.data![0].assetYear!;
                            }
                            if (state.assetDetailResponseModel.data![0]
                                    .chassisNo !=
                                null) {
                              ctrlChasisNo.text = state
                                  .assetDetailResponseModel.data![0].chassisNo!;
                            }
                            if (state.assetDetailResponseModel.data![0]
                                    .engineNo !=
                                null) {
                              ctrlEngineNo.text = state
                                  .assetDetailResponseModel.data![0].engineNo!;
                            }
                            if (state.assetDetailResponseModel.data![0]
                                    .platNo1 !=
                                null) {
                              ctrlPlatNo1.text = state
                                  .assetDetailResponseModel.data![0].platNo1!;
                              ctrlPlatNo2.text = state
                                  .assetDetailResponseModel.data![0].platNo2!;
                              ctrlPlatNo3.text = state
                                  .assetDetailResponseModel.data![0].platNo3!;
                            }
                          });
                          merkBloc.add(const MerkAttempt(''));
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
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
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
                                                    '1. Merk',
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
                                                alignment:
                                                    const Alignment(0, 0),
                                                children: [
                                                  BlocListener(
                                                      bloc: merkBloc,
                                                      listener:
                                                          (_, MerkState state) {
                                                        if (state
                                                            is MerkLoading) {}
                                                        if (state
                                                            is MerkLoaded) {}
                                                        if (state
                                                            is MerkError) {}
                                                        if (state
                                                            is MerkException) {}
                                                      },
                                                      child: BlocBuilder(
                                                          bloc: merkBloc,
                                                          builder: (_,
                                                              MerkState state) {
                                                            if (state
                                                                is MerkLoading) {}
                                                            if (state
                                                                is MerkLoaded) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  _showBottomMerk(
                                                                      state
                                                                          .lookUpMerkModel);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 280,
                                                                  height: 55,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.1)),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.1),
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
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          16.0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      selectMerk ==
                                                                              ''
                                                                          ? 'Select Merk'
                                                                          : selectMerk,
                                                                      style: TextStyle(
                                                                          color: selectMerk == ''
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
                                                                ),
                                                              );
                                                            }
                                                            return Container(
                                                              width: 280,
                                                              height: 55,
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
                                                                  '',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5),
                                                                      fontSize:
                                                                          15,
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
                                                    '2. Model',
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
                                                alignment:
                                                    const Alignment(0, 0),
                                                children: [
                                                  BlocListener(
                                                      bloc: modelBloc,
                                                      listener: (_,
                                                          ModelState state) {
                                                        if (state
                                                            is ModelLoading) {}
                                                        if (state
                                                            is ModelLoaded) {}
                                                        if (state
                                                            is ModelError) {}
                                                        if (state
                                                            is ModelException) {}
                                                      },
                                                      child: BlocBuilder(
                                                          bloc: modelBloc,
                                                          builder: (_,
                                                              ModelState
                                                                  state) {
                                                            if (state
                                                                is ModelLoading) {}
                                                            if (state
                                                                is ModelLoaded) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  _showBottomModel(
                                                                      state
                                                                          .lookUpMerkModel);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 280,
                                                                  height: 55,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.1)),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.1),
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
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          16.0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      selectModel ==
                                                                              ''
                                                                          ? 'Select Model'
                                                                          : selectModel,
                                                                      style: TextStyle(
                                                                          color: selectModel == ''
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
                                                                ),
                                                              );
                                                            }
                                                            return Container(
                                                              width: 280,
                                                              height: 55,
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
                                                                  selectModel ==
                                                                          ''
                                                                      ? ''
                                                                      : selectModel,
                                                                  style: TextStyle(
                                                                      color: selectType == ''
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
                                                    '3. Type',
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
                                                alignment:
                                                    const Alignment(0, 0),
                                                children: [
                                                  BlocListener(
                                                      bloc: typeBloc,
                                                      listener:
                                                          (_, TypeState state) {
                                                        if (state
                                                            is TypeLoading) {}
                                                        if (state
                                                            is TypeLoaded) {}
                                                        if (state
                                                            is TypeError) {}
                                                        if (state
                                                            is TypeException) {}
                                                      },
                                                      child: BlocBuilder(
                                                          bloc: typeBloc,
                                                          builder: (_,
                                                              TypeState state) {
                                                            if (state
                                                                is TypeLoading) {}
                                                            if (state
                                                                is TypeLoaded) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  _showBottomType(
                                                                      state
                                                                          .lookUpMerkModel);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 280,
                                                                  height: 55,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.1)),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.1),
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
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          16.0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      selectType ==
                                                                              ''
                                                                          ? 'Type'
                                                                          : selectType,
                                                                      style: TextStyle(
                                                                          color: selectType == ''
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
                                                                ),
                                                              );
                                                            }
                                                            return Container(
                                                              width: 280,
                                                              height: 55,
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
                                                                  selectType ==
                                                                          ''
                                                                      ? ''
                                                                      : selectType,
                                                                  style: TextStyle(
                                                                      color: selectType == ''
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
                                                    '4. Asset Amount',
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
                                                shadowColor: Colors.grey
                                                    .withOpacity(0.4),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: const BorderSide(
                                                        width: 1.0,
                                                        color:
                                                            Color(0xFFEAEAEA))),
                                                child: SizedBox(
                                                  width: 280,
                                                  height: 55,
                                                  child: TextFormField(
                                                    controller: ctrlAmount,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    onChanged: (string) {
                                                      assetAmountValue = string;
                                                      string = GeneralUtil
                                                          .formatNumber(
                                                              string.replaceAll(
                                                                  '.', ''));
                                                      ctrlAmount.value =
                                                          TextEditingValue(
                                                        text: string,
                                                        selection: TextSelection
                                                            .collapsed(
                                                                offset: string
                                                                    .length),
                                                      );
                                                    },
                                                    decoration: InputDecoration(
                                                        prefix: Padding(
                                                          padding: const EdgeInsets
                                                                  .only(
                                                              right:
                                                                  4.0), // Adjust the padding as needed
                                                          child: Text(GeneralUtil
                                                              .currency), // Your prefix text here
                                                        ),
                                                        hintText:
                                                            'Asset Amount',
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
                                            ],
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
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
                                                    '5. Condition',
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
                                                          condition = 'New';
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: condition ==
                                                                  'New'
                                                              ? primaryColor
                                                              : const Color(
                                                                  0xFFE1E1E1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: const Center(
                                                            child: Text('New',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
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
                                                          condition = 'Used';
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: condition ==
                                                                  'Used'
                                                              ? primaryColor
                                                              : const Color(
                                                                  0xFFE1E1E1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: const Center(
                                                            child: Text('Used',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    '6. Colour',
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
                                                shadowColor: Colors.grey
                                                    .withOpacity(0.4),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: const BorderSide(
                                                        width: 1.0,
                                                        color:
                                                            Color(0xFFEAEAEA))),
                                                child: SizedBox(
                                                  width: 280,
                                                  height: 55,
                                                  child: TextFormField(
                                                    controller: ctrlColor,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                        hintText: 'Colour',
                                                        isDense: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                16.0,
                                                                20.0,
                                                                20.0,
                                                                8.0),
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
                                                    '7. Asset Year',
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
                                                shadowColor: Colors.grey
                                                    .withOpacity(0.4),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: const BorderSide(
                                                        width: 1.0,
                                                        color:
                                                            Color(0xFFEAEAEA))),
                                                child: SizedBox(
                                                  width: 190,
                                                  height: 55,
                                                  child: TextFormField(
                                                    controller: ctrlYear,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                          4),
                                                    ],
                                                    decoration: InputDecoration(
                                                        hintText: 'Asset Year',
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
                                            ],
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
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
                                                children: [
                                                  const Text(
                                                    '8. Chasis No',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  condition == 'New'
                                                      ? Container()
                                                      : const Text(
                                                          ' *',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
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
                                                        color:
                                                            Color(0xFFEAEAEA))),
                                                child: SizedBox(
                                                  width: 280,
                                                  height: 55,
                                                  child: TextFormField(
                                                    controller: ctrlChasisNo,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                        hintText: 'Chasis No',
                                                        isDense: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                16.0,
                                                                20.0,
                                                                20.0,
                                                                8.0),
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
                                                children: [
                                                  const Text(
                                                    '9. Engine No',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  condition == 'New'
                                                      ? Container()
                                                      : const Text(
                                                          ' *',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
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
                                                        color:
                                                            Color(0xFFEAEAEA))),
                                                child: SizedBox(
                                                  width: 280,
                                                  height: 55,
                                                  child: TextFormField(
                                                    controller: ctrlEngineNo,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                        hintText: 'Engine No',
                                                        isDense: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                16.0,
                                                                20.0,
                                                                20.0,
                                                                8.0),
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
                                                children: [
                                                  const Text(
                                                    '10. Plat no',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  condition == 'New'
                                                      ? Container()
                                                      : const Text(
                                                          ' *',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                              BorderRadius
                                                                  .circular(10),
                                                          side: const BorderSide(
                                                              width: 1.0,
                                                              color: Color(
                                                                  0xFFEAEAEA))),
                                                      child: SizedBox(
                                                        width: 62,
                                                        height: 55,
                                                        child: TextFormField(
                                                          controller:
                                                              ctrlPlatNo1,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          inputFormatters: <
                                                              TextInputFormatter>[
                                                            LengthLimitingTextInputFormatter(
                                                                2)
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText: 'B',
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
                                                                      Colors
                                                                          .white,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                              BorderRadius
                                                                  .circular(10),
                                                          side: const BorderSide(
                                                              width: 1.0,
                                                              color: Color(
                                                                  0xFFEAEAEA))),
                                                      child: SizedBox(
                                                        width: 120,
                                                        height: 55,
                                                        child: TextFormField(
                                                          controller:
                                                              ctrlPlatNo2,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: <
                                                              TextInputFormatter>[
                                                            LengthLimitingTextInputFormatter(
                                                                4)
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      '1234',
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
                                                                      Colors
                                                                          .white,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                              BorderRadius
                                                                  .circular(10),
                                                          side: const BorderSide(
                                                              width: 1.0,
                                                              color: Color(
                                                                  0xFFEAEAEA))),
                                                      child: SizedBox(
                                                        width: 68,
                                                        height: 55,
                                                        child: TextFormField(
                                                          controller:
                                                              ctrlPlatNo3,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          inputFormatters: <
                                                              TextInputFormatter>[
                                                            LengthLimitingTextInputFormatter(
                                                                3)
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      'XXX',
                                                                  isDense: true,
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          16.0,
                                                                          20.0,
                                                                          20.0,
                                                                          8.0),
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5)),
                                                                  filled: true,
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                        ],
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BlocListener(
                                              bloc: checkValidityBloc,
                                              listener: (_,
                                                  CheckValidityState state) {
                                                if (state
                                                    is CheckValidityLoading) {}
                                                if (state
                                                    is CheckValidityLoaded) {
                                                  setState(() {
                                                    ctrlStatus.text = state
                                                        .checkScoringResponseModel
                                                        .message!;
                                                  });
                                                }
                                                if (state
                                                    is CheckValidityError) {}
                                                if (state
                                                    is CheckValidityException) {}
                                              },
                                              child: BlocBuilder(
                                                  bloc: checkValidityBloc,
                                                  builder: (_,
                                                      CheckValidityState
                                                          state) {
                                                    if (state
                                                        is CheckValidityLoading) {
                                                      return const SizedBox(
                                                        width: 188,
                                                        height: 53,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }
                                                    if (state
                                                        is CheckValidityLoaded) {
                                                      return InkWell(
                                                        onTap: () {
                                                          checkValidityBloc.add(
                                                              const CheckValidityAttempt(
                                                                  'PASS'));
                                                        },
                                                        child: Container(
                                                          width: 188,
                                                          height: 53,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: const Center(
                                                              child: Text(
                                                                  'Check Validity',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600))),
                                                        ),
                                                      );
                                                    }

                                                    return InkWell(
                                                      onTap: () {
                                                        checkValidityBloc.add(
                                                            const CheckValidityAttempt(
                                                                'PASS'));
                                                      },
                                                      child: Container(
                                                        width: 188,
                                                        height: 53,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: const Center(
                                                            child: Text(
                                                                'Check Validity',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600))),
                                                      ),
                                                    );
                                                  })),
                                          const SizedBox(height: 18),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Validity Status',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 8),
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
                                                        color:
                                                            Color(0xFFEAEAEA))),
                                                child: SizedBox(
                                                  width: 280,
                                                  height: 55,
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    controller: ctrlStatus,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                        hintText: '-',
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
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              );
                            }
                            return _loading();
                          })),
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
                        bloc: updateAssetDataBloc,
                        listener: (_, UpdateAssetDataState state) {
                          if (state is UpdateAssetDataLoading) {}
                          if (state is UpdateAssetDataLoaded) {
                            Navigator.pushNamed(context,
                                StringRouterUtil.applicationForm5ScreenTabRoute,
                                arguments: UpdateTncRequestModel(
                                    pApplicationNo: widget
                                        .assetRequestModel.pApplicationNo));
                          }
                          if (state is UpdateAssetDataError) {
                            GeneralUtil().showSnackBar(context, state.error!);
                          }
                          if (state is UpdateAssetDataException) {}
                        },
                        child: BlocBuilder(
                            bloc: updateAssetDataBloc,
                            builder: (_, UpdateAssetDataState state) {
                              if (state is UpdateAssetDataLoading) {
                                return const SizedBox(
                                  width: 200,
                                  height: 45,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state is UpdateAssetDataLoaded) {
                                return InkWell(
                                  onTap: () {
                                    if (condition == 'New') {
                                      if (ctrlAmount.text.isEmpty ||
                                          ctrlAmount.text == '' ||
                                          ctrlColor.text.isEmpty ||
                                          ctrlColor.text == '' ||
                                          ctrlYear.text.isEmpty ||
                                          ctrlYear.text == '' ||
                                          selectModel == '' ||
                                          selectType == '') {
                                        EmptyWidget().showBottomEmpty(context);
                                      } else {
                                        updateAssetDataBloc.add(
                                            UpdateAssetDataAttempt(
                                                UpdateAssetRequestModel(
                                                    pApplicationNo: widget
                                                        .assetRequestModel
                                                        .pApplicationNo,
                                                    pAssetAmount:
                                                        double
                                                                .parse(
                                                                    assetAmountValue)
                                                            .toInt(),
                                                    pAssetCondition: condition,
                                                    pAssetYear: ctrlYear.text,
                                                    pChassisNo:
                                                        ctrlChasisNo.text,
                                                    pColour: ctrlColor.text,
                                                    pEngineNo:
                                                        ctrlEngineNo.text,
                                                    pPlatNo1: ctrlPlatNo1.text,
                                                    pPlatNo2: ctrlPlatNo2.text,
                                                    pPlatNo3: ctrlPlatNo3.text,
                                                    pVehicleMerkCode:
                                                        selectMerkCode,
                                                    pVehicleModelCode:
                                                        selectModelCode,
                                                    pVehicleTypeCode:
                                                        selectTypeCode)));
                                      }
                                    } else {
                                      if (ctrlAmount.text.isEmpty ||
                                          ctrlAmount.text == '' ||
                                          ctrlColor.text.isEmpty ||
                                          ctrlColor.text == '' ||
                                          ctrlYear.text.isEmpty ||
                                          ctrlYear.text == '' ||
                                          ctrlChasisNo.text.isEmpty ||
                                          ctrlChasisNo.text == '' ||
                                          ctrlEngineNo.text.isEmpty ||
                                          ctrlEngineNo.text == '' ||
                                          ctrlPlatNo1.text.isEmpty ||
                                          ctrlPlatNo1.text == '' ||
                                          ctrlPlatNo2.text.isEmpty ||
                                          ctrlPlatNo2.text == '' ||
                                          ctrlPlatNo3.text.isEmpty ||
                                          ctrlPlatNo3.text == '' ||
                                          selectModel == '' ||
                                          selectType == '') {
                                        EmptyWidget().showBottomEmpty(context);
                                      } else {
                                        updateAssetDataBloc.add(
                                            UpdateAssetDataAttempt(
                                                UpdateAssetRequestModel(
                                                    pApplicationNo: widget
                                                        .assetRequestModel
                                                        .pApplicationNo,
                                                    pAssetAmount:
                                                        double
                                                                .parse(
                                                                    assetAmountValue)
                                                            .toInt(),
                                                    pAssetCondition: condition,
                                                    pAssetYear: ctrlYear.text,
                                                    pChassisNo:
                                                        ctrlChasisNo.text,
                                                    pColour: ctrlColor.text,
                                                    pEngineNo:
                                                        ctrlEngineNo.text,
                                                    pPlatNo1: ctrlPlatNo1.text,
                                                    pPlatNo2: ctrlPlatNo2.text,
                                                    pPlatNo3: ctrlPlatNo3.text,
                                                    pVehicleMerkCode:
                                                        selectMerkCode,
                                                    pVehicleModelCode:
                                                        selectModelCode,
                                                    pVehicleTypeCode:
                                                        selectTypeCode)));
                                      }
                                    }
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
                                onTap: ctrlStatus.text.isEmpty ||
                                        ctrlStatus.text == 'NOT VALID'
                                    ? null
                                    : () {
                                        if (condition == 'New') {
                                          if (ctrlAmount.text.isEmpty ||
                                              ctrlAmount.text == '' ||
                                              ctrlColor.text.isEmpty ||
                                              ctrlColor.text == '' ||
                                              ctrlYear.text.isEmpty ||
                                              ctrlYear.text == '' ||
                                              selectModel == '' ||
                                              selectType == '') {
                                            EmptyWidget()
                                                .showBottomEmpty(context);
                                          } else {
                                            updateAssetDataBloc.add(
                                                UpdateAssetDataAttempt(
                                                    UpdateAssetRequestModel(
                                                        pApplicationNo: widget
                                                            .assetRequestModel
                                                            .pApplicationNo,
                                                        pAssetAmount: double
                                                                .parse(
                                                                    assetAmountValue)
                                                            .toInt(),
                                                        pAssetCondition:
                                                            condition,
                                                        pAssetYear:
                                                            ctrlYear.text,
                                                        pChassisNo:
                                                            ctrlChasisNo.text,
                                                        pColour: ctrlColor.text,
                                                        pEngineNo:
                                                            ctrlEngineNo.text,
                                                        pPlatNo1:
                                                            ctrlPlatNo1.text,
                                                        pPlatNo2:
                                                            ctrlPlatNo2.text,
                                                        pPlatNo3:
                                                            ctrlPlatNo3.text,
                                                        pVehicleMerkCode:
                                                            selectMerkCode,
                                                        pVehicleModelCode:
                                                            selectModelCode,
                                                        pVehicleTypeCode:
                                                            selectTypeCode)));
                                          }
                                        } else {
                                          if (ctrlAmount.text.isEmpty ||
                                              ctrlAmount.text == '' ||
                                              ctrlColor.text.isEmpty ||
                                              ctrlColor.text == '' ||
                                              ctrlYear.text.isEmpty ||
                                              ctrlYear.text == '' ||
                                              ctrlChasisNo.text.isEmpty ||
                                              ctrlChasisNo.text == '' ||
                                              ctrlEngineNo.text.isEmpty ||
                                              ctrlEngineNo.text == '' ||
                                              ctrlPlatNo1.text.isEmpty ||
                                              ctrlPlatNo1.text == '' ||
                                              ctrlPlatNo2.text.isEmpty ||
                                              ctrlPlatNo2.text == '' ||
                                              ctrlPlatNo3.text.isEmpty ||
                                              ctrlPlatNo3.text == '' ||
                                              selectModel == '' ||
                                              selectType == '') {
                                            EmptyWidget()
                                                .showBottomEmpty(context);
                                          } else {
                                            updateAssetDataBloc.add(
                                                UpdateAssetDataAttempt(
                                                    UpdateAssetRequestModel(
                                                        pApplicationNo: widget
                                                            .assetRequestModel
                                                            .pApplicationNo,
                                                        pAssetAmount: double
                                                                .parse(
                                                                    assetAmountValue)
                                                            .toInt(),
                                                        pAssetCondition:
                                                            condition,
                                                        pAssetYear:
                                                            ctrlYear.text,
                                                        pChassisNo:
                                                            ctrlChasisNo.text,
                                                        pColour: ctrlColor.text,
                                                        pEngineNo:
                                                            ctrlEngineNo.text,
                                                        pPlatNo1:
                                                            ctrlPlatNo1.text,
                                                        pPlatNo2:
                                                            ctrlPlatNo2.text,
                                                        pPlatNo3:
                                                            ctrlPlatNo3.text,
                                                        pVehicleMerkCode:
                                                            selectMerkCode,
                                                        pVehicleModelCode:
                                                            selectModelCode,
                                                        pVehicleTypeCode:
                                                            selectTypeCode)));
                                          }
                                        }
                                      },
                                child: Container(
                                  width: 200,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: ctrlStatus.text.isEmpty ||
                                            ctrlStatus.text == 'NOT VALID'
                                        ? const Color(0xFFE1E1E1)
                                        : thirdColor,
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

class _IDRCurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;

    // If the length is 0, return the current value
    if (newTextLength == 0) {
      return newValue;
    }

    // Determine the cursor position before formatting
    final int cursorBefore = newValue.selection.baseOffset;

    // Remove non-numeric characters
    final String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Format the cleaned text as IDR currency
    final String formattedText = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
    ).format(int.parse(cleanedText) / 1000);

    // Calculate the new cursor position after formatting
    final int cursorAfter =
        cursorBefore + (formattedText.length - cleanedText.length);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorAfter),
    );
  }
}
