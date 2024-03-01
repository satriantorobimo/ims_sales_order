import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/empty_widget.dart';
import 'package:sales_order/features/application_form_5/data/look_up_insurance_package_model.dart';
import 'package:sales_order/features/application_form_5/domain/repo/form_5_repo.dart';
import 'package:sales_order/features/application_form_5/presentation/bloc/insurance_bloc/bloc.dart';
import 'package:sales_order/features/simulation/data/send_pdf_request_model.dart';
import 'package:sales_order/features/simulation/data/simulation_request_model.dart';
import 'package:sales_order/features/simulation/domain/repo/simulation_repo.dart';
import 'package:sales_order/features/simulation/presentation/bloc/send_pdf_bloc/bloc.dart';
import 'package:sales_order/features/simulation/presentation/bloc/simulation_bloc/bloc.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/database_helper.dart';
import 'package:sales_order/utility/general_util.dart';

class SimulationTabScreen extends StatefulWidget {
  const SimulationTabScreen({super.key});

  @override
  State<SimulationTabScreen> createState() => _SimulationTabScreenState();
}

class _SimulationTabScreenState extends State<SimulationTabScreen>
    with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  List<String> feeType = ['ADVANCE', 'ARREAR'];
  AnimationController? animationController;
  String otrValue = '';
  String adminValue = '0';
  String provisiValue = '0';
  String othersValue = '0';
  double dpAmount = 0.00;
  double financingAmount = 0.00;
  int selectIndexInsurance = 10000;
  String selectInsurance = '';
  String selectInsuranceCode = '';
  String firstPaymentType = '';
  TextEditingController ctrlOtr = TextEditingController();
  TextEditingController ctrlDp = TextEditingController();
  TextEditingController ctrlFullName = TextEditingController();
  TextEditingController ctrlPhoneNumber = TextEditingController();
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlVehicleName = TextEditingController();
  TextEditingController ctrlFr = TextEditingController();
  TextEditingController ctrlAdmin = TextEditingController(text: '0');
  TextEditingController ctrlProvisi = TextEditingController(text: '0');
  TextEditingController ctrlOthers = TextEditingController(text: '0');

  InsuranceBloc insuranceBloc = InsuranceBloc(form5repo: Form5Repo());
  SimulationBloc simulationBloc =
      SimulationBloc(simulationRepo: SimulationRepo());
  SendPdfBloc sendPdfBloc = SendPdfBloc(simulationRepo: SimulationRepo());

  @override
  void initState() {
    insuranceBloc.add(const InsuranceAttempt(''));
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController!.repeat();
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  Future<void> _showBottomInsurance(
      LookUpInsurancePackageModel lookUpInsurancePackageModel) {
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
                        'Insurance',
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
                                tempList = lookUpInsurancePackageModel.data!
                                    .where((item) => item.packageName!
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
                              : lookUpInsurancePackageModel.data!.length,
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
                                  if (selectIndexInsurance == index) {
                                    selectInsurance = '';
                                    selectInsuranceCode = '';
                                    selectIndexInsurance = 1000;
                                  } else {
                                    selectInsurance = tempList.isNotEmpty
                                        ? tempList[index].packageName!
                                        : lookUpInsurancePackageModel
                                            .data![index].packageName!;
                                    selectInsuranceCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpInsurancePackageModel
                                            .data![index].code!;
                                    selectIndexInsurance = index;
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
                                        ? tempList[index].packageName!
                                        : lookUpInsurancePackageModel
                                            .data![index].packageName!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  selectIndexInsurance == index
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

  Future<void> _showBottomFeeType() {
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
                    'First Payment Type',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                ),
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 24),
                      itemCount: feeType.length,
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
                              firstPaymentType = feeType[index];
                            });
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                feeType[index],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              firstPaymentType == feeType[index]
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Simulation',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                // setState(() {
                ctrlFullName.clear();
                ctrlPhoneNumber.clear();
                ctrlEmail.clear();
                ctrlVehicleName.clear();
                ctrlOtr.clear();
                ctrlDp.clear();
                ctrlFr.clear();
                ctrlAdmin.text = '0';
                adminValue = '0';
                ctrlProvisi.text = '0';
                provisiValue = '0';
                ctrlOthers.text = '0';
                othersValue = '0';
                // });
                setState(() {
                  dpAmount = 0.00;
                  financingAmount = 0.00;
                  firstPaymentType = '';
                  selectInsurance = '';
                });
              },
              child: Row(
                children: const [
                  SizedBox(width: 16),
                  Text(
                    'Reset',
                    style: TextStyle(
                      color: Color(0xFF222222),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.refresh_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Client Info',
                      style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Full Name',
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
                              shadowColor: Colors.grey.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                      width: 1.0, color: Color(0xFFEAEAEA))),
                              child: SizedBox(
                                width: 280,
                                height: 55,
                                child: TextFormField(
                                  controller: ctrlFullName,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: 'Full Name',
                                      isDense: true,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          16.0, 20.0, 20.0, 8.0),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Phone No',
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
                              width: 280,
                              child: Material(
                                elevation: 6,
                                shadowColor: Colors.grey.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        width: 1.0, color: Color(0xFFEAEAEA))),
                                child: SizedBox(
                                  width: 180,
                                  height: 55,
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
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                16.0, 20.0, 20.0, 8.0),
                                        hintStyle: TextStyle(
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
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Email',
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
                              shadowColor: Colors.grey.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                      width: 1.0, color: Color(0xFFEAEAEA))),
                              child: SizedBox(
                                width: 280,
                                height: 55,
                                child: TextFormField(
                                  controller: ctrlEmail,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9@a-zA-Z.-]")),
                                  ],
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      hintText: 'Email',
                                      isDense: true,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          16.0, 20.0, 20.0, 8.0),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Vehicle Name',
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
                              shadowColor: Colors.grey.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                      width: 1.0, color: Color(0xFFEAEAEA))),
                              child: SizedBox(
                                width: 280,
                                height: 55,
                                child: TextFormField(
                                  controller: ctrlVehicleName,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: 'Vehicle Name',
                                      isDense: true,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          16.0, 20.0, 20.0, 8.0),
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
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 10,
                color: const Color(0xFFD9D9D9).withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'T&C',
                      style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'OTR',
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
                              shadowColor: Colors.grey.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      width: 1.0, color: Color(0xFFEAEAEA))),
                              child: SizedBox(
                                width: 280,
                                height: 55,
                                child: TextFormField(
                                  controller: ctrlOtr,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (string) {
                                    otrValue = string;
                                    string = GeneralUtil.formatNumber(
                                        string.replaceAll('.', ''));
                                    ctrlOtr.value = TextEditingValue(
                                      text: string,
                                      selection: TextSelection.collapsed(
                                          offset: string.length),
                                    );

                                    if (ctrlOtr.text == '' ||
                                        ctrlOtr.text.isEmpty ||
                                        ctrlDp.text.isEmpty ||
                                        ctrlDp.text == '') {
                                    } else {
                                      setState(() {
                                        dpAmount = ((int.parse(otrValue) *
                                                int.parse(ctrlDp.text)) /
                                            100);
                                        financingAmount =
                                            (int.parse(otrValue) - dpAmount);
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                      prefix: Padding(
                                        padding: const EdgeInsets.only(
                                            right:
                                                4.0), // Adjust the padding as needed
                                        child: Text(GeneralUtil
                                            .currency), // Your prefix text here
                                      ),
                                      hintText: 'OTR',
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'DP (%)',
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
                              shadowColor: Colors.grey.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      width: 1.0, color: Color(0xFFEAEAEA))),
                              child: SizedBox(
                                width: 280,
                                height: 55,
                                child: TextFormField(
                                  controller: ctrlDp,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(16),
                                    LimitRangeTextInputFormatter(1, 100),
                                  ],
                                  onChanged: (string) {
                                    if (ctrlOtr.text == '' ||
                                        ctrlOtr.text.isEmpty ||
                                        ctrlDp.text.isEmpty ||
                                        ctrlDp.text == '') {
                                    } else {
                                      setState(() {
                                        dpAmount = ((int.parse(otrValue) *
                                                int.parse(string)) /
                                            100);
                                        financingAmount =
                                            (int.parse(otrValue) - dpAmount);
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'DP(%)',
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DP Amount',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 280,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                                color: const Color(0xFFFAF9F9),
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
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  GeneralUtil.convertToIdr(dpAmount, 2),
                                  style: const TextStyle(
                                      color: Color(0xFF6E6E6E),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Financing Amount',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 280,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                                color: const Color(0xFFFAF9F9),
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
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  GeneralUtil.convertToIdr(financingAmount, 2),
                                  style: const TextStyle(
                                      color: Color(0xFF6E6E6E),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'First Payment Type',
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
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showBottomFeeType();
                                  },
                                  child: Container(
                                    width: 280,
                                    height: 55,
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
                                        firstPaymentType == ''
                                            ? 'Select First Payment Type'
                                            : firstPaymentType,
                                        style: TextStyle(
                                            color: firstPaymentType == ''
                                                ? Colors.grey.withOpacity(0.5)
                                                : Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  right: 16,
                                  top: 14,
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFF3D3D3D),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Rate (%)',
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
                              shadowColor: Colors.grey.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      width: 1.0, color: Color(0xFFEAEAEA))),
                              child: SizedBox(
                                width: 280,
                                height: 55,
                                child: TextFormField(
                                  controller: ctrlFr,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(16),
                                    LimitRangeTextInputFormatter(1, 100),
                                  ],
                                  decoration: InputDecoration(
                                      hintText: 'Rate (%) ',
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Insurance Package',
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
                              children: [
                                BlocListener(
                                    bloc: insuranceBloc,
                                    listener: (_, InsuranceState state) {
                                      if (state is InsuranceLoading) {}
                                      if (state is InsuranceLoaded) {}
                                      if (state is InsuranceError) {}
                                      if (state is InsuranceException) {}
                                    },
                                    child: BlocBuilder(
                                        bloc: insuranceBloc,
                                        builder: (_, InsuranceState state) {
                                          if (state is InsuranceLoading) {}
                                          if (state is InsuranceLoaded) {
                                            return InkWell(
                                              onTap: () {
                                                _showBottomInsurance(state
                                                    .lookUpInsurancePackageModel);
                                              },
                                              child: Container(
                                                width: 280,
                                                height: 55,
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
                                                      offset: const Offset(-6,
                                                          4), // Shadow position
                                                    ),
                                                  ],
                                                ),
                                                padding: const EdgeInsets.only(
                                                    left: 16.0, right: 32.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    selectInsurance == ''
                                                        ? 'Select Insurance'
                                                        : selectInsurance,
                                                    style: TextStyle(
                                                        color: selectInsurance ==
                                                                ''
                                                            ? Colors.grey
                                                                .withOpacity(
                                                                    0.5)
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
                                            width: 280,
                                            height: 55,
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
                                                left: 16.0, right: 32.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          );
                                        })),
                                const Positioned(
                                  right: 16,
                                  top: 14,
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFF3D3D3D),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 280,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Admin',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
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
                                width: 280,
                                height: 55,
                                child: TextFormField(
                                  controller: ctrlAdmin,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (string) {
                                    adminValue = string;
                                    string = GeneralUtil.formatNumber(
                                        string.replaceAll('.', ''));
                                    ctrlAdmin.value = TextEditingValue(
                                      text: string,
                                      selection: TextSelection.collapsed(
                                          offset: string.length),
                                    );
                                  },
                                  decoration: InputDecoration(
                                      prefix: Padding(
                                        padding: const EdgeInsets.only(
                                            right:
                                                4.0), // Adjust the padding as needed
                                        child: Text(GeneralUtil
                                            .currency), // Your prefix text here
                                      ),
                                      hintText: 'Admin',
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Provisi',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
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
                                width: 280,
                                height: 55,
                                child: TextFormField(
                                  controller: ctrlProvisi,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (string) {
                                    provisiValue = string;
                                    string = GeneralUtil.formatNumber(
                                        string.replaceAll('.', ''));
                                    ctrlProvisi.value = TextEditingValue(
                                      text: string,
                                      selection: TextSelection.collapsed(
                                          offset: string.length),
                                    );
                                  },
                                  decoration: InputDecoration(
                                      prefix: Padding(
                                        padding: const EdgeInsets.only(
                                            right:
                                                4.0), // Adjust the padding as needed
                                        child: Text(GeneralUtil
                                            .currency), // Your prefix text here
                                      ),
                                      hintText: 'Provisi',
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Others Fee',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
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
                                width: 280,
                                height: 55,
                                child: TextFormField(
                                  controller: ctrlOthers,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (string) {
                                    othersValue = string;
                                    string = GeneralUtil.formatNumber(
                                        string.replaceAll('.', ''));
                                    ctrlOthers.value = TextEditingValue(
                                      text: string,
                                      selection: TextSelection.collapsed(
                                          offset: string.length),
                                    );
                                  },
                                  decoration: InputDecoration(
                                      prefix: Padding(
                                        padding: const EdgeInsets.only(
                                            right:
                                                4.0), // Adjust the padding as needed
                                        child: Text(GeneralUtil
                                            .currency), // Your prefix text here
                                      ),
                                      hintText: 'Others Fee',
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
                        const SizedBox(
                          width: 280,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 10,
                color: const Color(0xFFD9D9D9).withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Summary',
                          style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                if (ctrlFullName.text.isEmpty ||
                                    ctrlFullName.text == '' ||
                                    ctrlPhoneNumber.text.isEmpty ||
                                    ctrlPhoneNumber.text == '' ||
                                    ctrlEmail.text.isEmpty ||
                                    ctrlEmail.text == '' ||
                                    ctrlVehicleName.text.isEmpty ||
                                    ctrlVehicleName.text == '' ||
                                    ctrlOtr.text.isEmpty ||
                                    ctrlOtr.text == '' ||
                                    ctrlDp.text.isEmpty ||
                                    ctrlDp.text == '' ||
                                    ctrlFr.text.isEmpty ||
                                    ctrlFr.text == '' ||
                                    selectInsuranceCode == '' ||
                                    firstPaymentType == '') {
                                  EmptyWidget().showBottomEmpty(context);
                                } else {
                                  final data =
                                      await DatabaseHelper.getUserData();

                                  simulationBloc.add(SimulationAttempt(
                                      SimulationRequestModel(
                                          pMarketingCode: data[0]['uid'],
                                          pDpAmount: dpAmount.toInt(),
                                          pFinancingAmount:
                                              financingAmount.toInt(),
                                          pFirstPaymentType: firstPaymentType,
                                          pFlatRate: int.parse(ctrlFr.text),
                                          pInsurancePackageCode:
                                              selectInsuranceCode,
                                          pAdminFee: int.parse(adminValue),
                                          pProvisiFee: int.parse(provisiValue),
                                          pOthersFee: int.parse(othersValue))));
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.18,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: thirdColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                    child: Text('Calculate',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600))),
                              ),
                            ),
                            const SizedBox(width: 16),
                            BlocListener(
                                bloc: sendPdfBloc,
                                listener: (_, SendPdfState state) {
                                  if (state is SendPdfLoading) {
                                    _loadingAttempt(context);
                                  }
                                  if (state is SendPdfLoaded) {
                                    Navigator.pop(context);
                                    GeneralUtil().showSnackBarSuccess(
                                        context, 'Berhasil Mengirim PDF');
                                  }
                                  if (state is SendPdfError) {
                                    Navigator.pop(context);
                                    GeneralUtil()
                                        .showSnackBar(context, state.error!);
                                  }
                                  if (state is SendPdfException) {
                                    Navigator.pop(context);
                                    GeneralUtil().showSnackBar(
                                        context, 'Terjadi Kesalahan Sistem');
                                  }
                                },
                                child: BlocBuilder(
                                    bloc: sendPdfBloc,
                                    builder: (_, SendPdfState state) {
                                      if (state is SendPdfLoading) {
                                        return InkWell(
                                          onTap: () {},
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.18,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Center(
                                                child: Text('Send PDF',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600))),
                                          ),
                                        );
                                      }
                                      if (state is SendPdfLoaded) {
                                        return InkWell(
                                          onTap: () async {
                                            if (ctrlFullName.text.isEmpty ||
                                                ctrlFullName.text == '' ||
                                                ctrlPhoneNumber.text.isEmpty ||
                                                ctrlPhoneNumber.text == '' ||
                                                ctrlEmail.text.isEmpty ||
                                                ctrlEmail.text == '' ||
                                                ctrlVehicleName.text.isEmpty ||
                                                ctrlVehicleName.text == '' ||
                                                ctrlOtr.text.isEmpty ||
                                                ctrlOtr.text == '' ||
                                                ctrlDp.text.isEmpty ||
                                                ctrlDp.text == '' ||
                                                ctrlFr.text.isEmpty ||
                                                ctrlFr.text == '' ||
                                                selectInsuranceCode == '' ||
                                                firstPaymentType == '') {
                                              EmptyWidget()
                                                  .showBottomEmpty(context);
                                            } else {
                                              final data = await DatabaseHelper
                                                  .getUserData();
                                              sendPdfBloc.add(SendPdfAttempt(SendPdfRequestModel(
                                                  pAdminFee:
                                                      int.parse(adminValue),
                                                  pClientEmail: ctrlEmail.text,
                                                  pClientName:
                                                      ctrlFullName.text,
                                                  pClientPhoneNo:
                                                      ctrlPhoneNumber.text,
                                                  pDpAmount: dpAmount.toInt(),
                                                  pDpPct:
                                                      int.parse(ctrlDp.text),
                                                  pFinancingAmount:
                                                      financingAmount.toInt(),
                                                  pFirstPaymentType:
                                                      firstPaymentType,
                                                  pFlatRate:
                                                      int.parse(ctrlFr.text),
                                                  pInsurancePackageCode:
                                                      selectInsuranceCode,
                                                  pInsurancePackageName:
                                                      selectInsurance,
                                                  pMarketingCode: data[0]
                                                      ['uid'],
                                                  pOthersFee:
                                                      int.parse(othersValue),
                                                  pOtr: int.parse(otrValue),
                                                  pProvisiFee:
                                                      int.parse(provisiValue),
                                                  pVehicleName:
                                                      ctrlVehicleName.text)));
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.18,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Center(
                                                child: Text('Send PDF',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600))),
                                          ),
                                        );
                                      }
                                      return InkWell(
                                        onTap: () async {
                                          if (ctrlFullName.text.isEmpty ||
                                              ctrlFullName.text == '' ||
                                              ctrlPhoneNumber.text.isEmpty ||
                                              ctrlPhoneNumber.text == '' ||
                                              ctrlEmail.text.isEmpty ||
                                              ctrlEmail.text == '' ||
                                              ctrlVehicleName.text.isEmpty ||
                                              ctrlVehicleName.text == '' ||
                                              ctrlOtr.text.isEmpty ||
                                              ctrlOtr.text == '' ||
                                              ctrlDp.text.isEmpty ||
                                              ctrlDp.text == '' ||
                                              ctrlFr.text.isEmpty ||
                                              ctrlFr.text == '' ||
                                              selectInsuranceCode == '' ||
                                              firstPaymentType == '') {
                                            EmptyWidget()
                                                .showBottomEmpty(context);
                                          } else {
                                            final data = await DatabaseHelper
                                                .getUserData();
                                            sendPdfBloc.add(SendPdfAttempt(
                                                SendPdfRequestModel(
                                                    pAdminFee: int.parse(
                                                        adminValue),
                                                    pClientEmail:
                                                        ctrlEmail.text,
                                                    pClientName:
                                                        ctrlFullName.text,
                                                    pClientPhoneNo:
                                                        ctrlPhoneNumber.text,
                                                    pDpAmount: dpAmount.toInt(),
                                                    pDpPct: int.parse(
                                                        ctrlDp.text),
                                                    pFinancingAmount:
                                                        financingAmount.toInt(),
                                                    pFirstPaymentType:
                                                        firstPaymentType,
                                                    pFlatRate:
                                                        int.parse(ctrlFr.text),
                                                    pInsurancePackageCode:
                                                        selectInsuranceCode,
                                                    pInsurancePackageName:
                                                        selectInsurance,
                                                    pMarketingCode: data[0]
                                                        ['uid'],
                                                    pOthersFee:
                                                        int.parse(othersValue),
                                                    pOtr: int.parse(otrValue),
                                                    pProvisiFee:
                                                        int.parse(provisiValue),
                                                    pVehicleName:
                                                        ctrlVehicleName.text)));
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Center(
                                              child: Text('Send PDF',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ),
                                      );
                                    })),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    BlocListener(
                        bloc: simulationBloc,
                        listener: (_, SimulationState state) {
                          if (state is SimulationLoading) {
                            _loadingAttempt(context);
                          }
                          if (state is SimulationLoaded) {
                            Navigator.pop(context);
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (_controller.hasClients) {
                                  _controller.jumpTo(
                                      _controller.position.maxScrollExtent);
                                }
                              });
                            });
                          }
                          if (state is SimulationError) {
                            Navigator.pop(context);
                            GeneralUtil().showSnackBar(context, state.error!);
                          }
                          if (state is SimulationException) {
                            Navigator.pop(context);
                            GeneralUtil().showSnackBar(
                                context, 'Terjadi Kesalahan Sistem');
                          }
                        },
                        child: BlocBuilder(
                            bloc: simulationBloc,
                            builder: (_, SimulationState state) {
                              if (state is SimulationLoading) {}
                              if (state is SimulationLoaded) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          height: 25,
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: const Text(
                                            'Tenor',
                                            style: TextStyle(
                                                color: Color(0xFFB5B7C0),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: 25,
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: const Text(
                                            'DP',
                                            style: TextStyle(
                                                color: Color(0xFFB5B7C0),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: 25,
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: const Text(
                                            'Admin',
                                            style: TextStyle(
                                                color: Color(0xFFB5B7C0),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: 25,
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: const Text(
                                            'Provisi',
                                            style: TextStyle(
                                                color: Color(0xFFB5B7C0),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: 25,
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: const Text(
                                            'Insurance',
                                            style: TextStyle(
                                                color: Color(0xFFB5B7C0),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: 25,
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            firstPaymentType == 'ARREAR'
                                                ? 'Others'
                                                : 'Others + First Installment',
                                            textAlign: TextAlign.justify,
                                            style: firstPaymentType == 'ARREAR'
                                                ? const TextStyle(
                                                    color: Color(0xFFB5B7C0),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold)
                                                : const TextStyle(
                                                    color: Color(0xFFB5B7C0),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: 25,
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: const Text(
                                            'TDP',
                                            style: TextStyle(
                                                color: Color(0xFFB5B7C0),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: 25,
                                          padding: const EdgeInsets.only(
                                              right: 16.0),
                                          child: const Text(
                                            'Installment',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: Color(0xFFB5B7C0),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 5,
                                      color: const Color(0xFFD9D9D9)
                                          .withOpacity(0.1),
                                    ),
                                    ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 8),
                                        itemCount: state.simulationResponseModel
                                            .data!.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0, bottom: 16.0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 3,
                                              color: const Color(0xFFD9D9D9)
                                                  .withOpacity(0.1),
                                            ),
                                          );
                                        },
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                height: 25,
                                                padding: const EdgeInsets.only(
                                                    left: 24.0),
                                                child: Text(
                                                  '${state.simulationResponseModel.data![index].tenor}',
                                                  style: const TextStyle(
                                                      color: Color(0xFF292D32),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                height: 25,
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  GeneralUtil.convertToIdr(
                                                      state
                                                          .simulationResponseModel
                                                          .data![index]
                                                          .dpAmount,
                                                      2),
                                                  style: const TextStyle(
                                                      color: Color(0xFF292D32),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                height: 25,
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  GeneralUtil.convertToIdr(
                                                      state
                                                          .simulationResponseModel
                                                          .data![index]
                                                          .adminFee,
                                                      2),
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      color: Color(0xFF292D32),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                height: 25,
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  GeneralUtil.convertToIdr(
                                                      state
                                                          .simulationResponseModel
                                                          .data![index]
                                                          .provisiFee,
                                                      2),
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      color: Color(0xFF292D32),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                height: 25,
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  GeneralUtil.convertToIdr(
                                                      state
                                                          .simulationResponseModel
                                                          .data![index]
                                                          .insuranceAmount,
                                                      2),
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      color: Color(0xFF292D32),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                height: 25,
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  GeneralUtil.convertToIdr(
                                                      state
                                                          .simulationResponseModel
                                                          .data![index]
                                                          .othersFee,
                                                      2),
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      color: Color(0xFF292D32),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                height: 25,
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  GeneralUtil.convertToIdr(
                                                      state
                                                          .simulationResponseModel
                                                          .data![index]
                                                          .tdp,
                                                      2),
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      color: Color(0xFF292D32),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                height: 25,
                                                padding: const EdgeInsets.only(
                                                    right: 24.0),
                                                child: Text(
                                                  GeneralUtil.convertToIdr(
                                                      state
                                                          .simulationResponseModel
                                                          .data![index]
                                                          .installmentAmount,
                                                      2),
                                                  textAlign: TextAlign.end,
                                                  style: const TextStyle(
                                                      color: Color(0xFF292D32),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                  ],
                                );
                              }
                              return Container();
                            })),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void _loadingAttempt(BuildContext context) {
    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          actionsPadding:
              const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Container(),
          titlePadding: const EdgeInsets.only(top: 20, left: 20),
          contentPadding: const EdgeInsets.only(
            top: 0,
            bottom: 24,
            left: 24,
            right: 24,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    valueColor: animationController!.drive(
                        ColorTween(begin: thirdColor, end: secondaryColor)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Mohon menunggu sebentar',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF575551)),
              ),
            ],
          ),
          actions: const [],
        );
      },
    );
  }
}
