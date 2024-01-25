import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/empty_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_3/data/look_up_dealer_model.dart'
    as dealer;
import 'package:sales_order/features/application_form_3/data/look_up_package_model.dart'
    as package;
import 'package:sales_order/features/application_form_3/data/update_loan_data_request_model.dart';
import 'package:sales_order/features/application_form_3/domain/repo/form_3_repo.dart';
import 'package:sales_order/features/application_form_3/presentation/bloc/dealer_bloc/bloc.dart';
import 'package:sales_order/features/application_form_3/presentation/bloc/loan_data_detail_bloc/bloc.dart';
import 'package:sales_order/features/application_form_3/presentation/bloc/package_bloc/bloc.dart';
import 'package:sales_order/features/application_form_3/presentation/bloc/update_loan_data_bloc/bloc.dart';
import 'package:sales_order/features/application_form_4/data/update_asset_request_model.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class ApplicationForm3TabScreen extends StatefulWidget {
  const ApplicationForm3TabScreen(
      {super.key, required this.updateLoanDataRequestModel});
  final UpdateLoanDataRequestModel updateLoanDataRequestModel;

  @override
  State<ApplicationForm3TabScreen> createState() =>
      _ApplicationForm3TabScreenState();
}

class _ApplicationForm3TabScreenState extends State<ApplicationForm3TabScreen> {
  int selectIndexPackage = 0;
  String selectPackage = '';
  String selectPackageCode = '';
  int selectIndexDealer = 0;
  String selectDealer = '';
  String selectDealerCode = '';
  bool isPackage = false;
  LoanDataDetailBloc loanDataDetailBloc =
      LoanDataDetailBloc(form3repo: Form3Repo());
  UpdateLoanDataBloc updateLoanDataBloc =
      UpdateLoanDataBloc(form3repo: Form3Repo());
  PackageBloc packageBloc = PackageBloc(form3repo: Form3Repo());
  DealerBloc dealerBloc = DealerBloc(form3repo: Form3Repo());
  TextEditingController ctrlRemark = TextEditingController();

  @override
  void initState() {
    loanDataDetailBloc.add(LoanDataDetailAttempt(
        widget.updateLoanDataRequestModel.pApplicationNo!));

    super.initState();
  }

  Future<void> _showBottom(package.LookUpPackageModel lookUpPackageModel) {
    List<package.Data> tempList = [];
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
                        'Package',
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
                                tempList = lookUpPackageModel.data!
                                    .where((item) => item.packageDescription!
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
                              : lookUpPackageModel.data!.length,
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
                                  if (selectIndexPackage == index) {
                                    selectPackage = '';
                                    selectPackageCode = '';
                                    selectIndexPackage = 10000;
                                  } else {
                                    selectPackage = tempList.isNotEmpty
                                        ? tempList[index].packageDescription!
                                        : lookUpPackageModel
                                            .data![index].packageDescription!;
                                    selectPackageCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpPackageModel.data![index].code!;
                                    selectIndexPackage = index;
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
                                        ? tempList[index].packageDescription!
                                        : lookUpPackageModel
                                            .data![index].packageDescription!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  selectIndexPackage == index
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

  Future<void> _showBottomDealer(dealer.LookUpDealerModel lookUpDealerModel) {
    List<dealer.Data> tempList = [];
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
                        'Dealer',
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
                                tempList = lookUpDealerModel.data!
                                    .where((item) => item.vendorName!
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
                              : lookUpDealerModel.data!.length,
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
                                  if (selectIndexDealer == index) {
                                    selectDealer = '';
                                    selectDealerCode = '';
                                    selectIndexDealer = 100000;
                                  } else {
                                    selectDealer = tempList.isNotEmpty
                                        ? tempList[index].vendorName!
                                        : lookUpDealerModel
                                            .data![index].vendorName!;
                                    selectDealerCode = tempList.isNotEmpty
                                        ? tempList[index].code!
                                        : lookUpDealerModel.data![index].code!;
                                    selectIndexDealer = index;
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
                                        ? tempList[index].vendorName!
                                        : lookUpDealerModel
                                            .data![index].vendorName!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  selectIndexDealer == index
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
                    OptionWidget(isUsed: true).showBottomOption(context,
                        widget.updateLoanDataRequestModel.pApplicationNo!);
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
                  child: BlocListener(
                      bloc: loanDataDetailBloc,
                      listener: (_, LoanDataDetailState state) {
                        if (state is LoanDataDetailLoading) {}
                        if (state is LoanDataDetailLoaded) {
                          setState(() {
                            if (state.loanDataDetailResponseModel.data![0]
                                    .packageCode !=
                                null) {
                              isPackage = true;
                              selectPackageCode = state
                                  .loanDataDetailResponseModel
                                  .data![0]
                                  .packageCode!;
                              selectPackage = state.loanDataDetailResponseModel
                                  .data![0].packageDescription!;
                            }
                            if (state.loanDataDetailResponseModel.data![0]
                                    .vendorCode !=
                                null) {
                              selectDealerCode = state
                                  .loanDataDetailResponseModel
                                  .data![0]
                                  .vendorCode!;
                              selectDealer = state.loanDataDetailResponseModel
                                  .data![0].vendorName!;
                            }
                            if (state.loanDataDetailResponseModel.data![0]
                                    .applicationRemarks !=
                                null) {
                              ctrlRemark.text = state
                                  .loanDataDetailResponseModel
                                  .data![0]
                                  .applicationRemarks!;
                            }
                          });

                          packageBloc.add(const PackageAttempt(''));
                          dealerBloc.add(const DealerAttempt(''));
                        }
                        if (state is LoanDataDetailError) {}
                        if (state is LoanDataDetailException) {}
                      },
                      child: BlocBuilder(
                          bloc: loanDataDetailBloc,
                          builder: (_, LoanDataDetailState state) {
                            if (state is LoanDataDetailLoading) {
                              return _loading();
                            }
                            if (state is LoanDataDetailLoaded) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
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
                                                    '1. Package',
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
                                                      bloc: packageBloc,
                                                      listener: (_,
                                                          PackageState state) {
                                                        if (state
                                                            is PackageLoading) {}
                                                        if (state
                                                            is PackageLoaded) {
                                                          setState(() {
                                                            selectIndexPackage =
                                                                1000;
                                                          });
                                                        }
                                                        if (state
                                                            is PackageError) {}
                                                        if (state
                                                            is PackageException) {}
                                                      },
                                                      child: BlocBuilder(
                                                          bloc: packageBloc,
                                                          builder: (_,
                                                              PackageState
                                                                  state) {
                                                            if (state
                                                                is PackageLoading) {}
                                                            if (state
                                                                is PackageLoaded) {
                                                              return InkWell(
                                                                onTap: isPackage
                                                                    ? null
                                                                    : () {
                                                                        _showBottom(
                                                                            state.lookUpPackageModel);
                                                                      },
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.38,
                                                                  height: 50,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.1)),
                                                                    color: isPackage
                                                                        ? const Color(
                                                                            0xFFFAF9F9)
                                                                        : Colors
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
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.33,
                                                                      child:
                                                                          Text(
                                                                        selectPackage ==
                                                                                ''
                                                                            ? 'Select Package'
                                                                            : selectPackage,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: selectPackage == ''
                                                                                ? Colors.grey.withOpacity(0.5)
                                                                                : isPackage
                                                                                    ? const Color(0xFF6E6E6E)
                                                                                    : Colors.black,
                                                                            fontSize: 15,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            return Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.38,
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
                                                  Positioned(
                                                    right: 16,
                                                    child: isPackage
                                                        ? Container()
                                                        : const Icon(
                                                            Icons
                                                                .search_rounded,
                                                            color: Color(
                                                                0xFF3D3D3D),
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
                                                    '2. Dealer',
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
                                                      bloc: dealerBloc,
                                                      listener: (_,
                                                          DealerState state) {
                                                        if (state
                                                            is DealerLoading) {}
                                                        if (state
                                                            is DealerLoaded) {
                                                          setState(() {
                                                            selectIndexDealer =
                                                                1000;
                                                          });
                                                        }
                                                        if (state
                                                            is DealerError) {}
                                                        if (state
                                                            is DealerException) {}
                                                      },
                                                      child: BlocBuilder(
                                                          bloc: dealerBloc,
                                                          builder: (_,
                                                              DealerState
                                                                  state) {
                                                            if (state
                                                                is DealerLoading) {}
                                                            if (state
                                                                is DealerLoaded) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  _showBottomDealer(
                                                                      state
                                                                          .lookUpDealerModel);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.38,
                                                                  height: 50,
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
                                                                      selectDealer ==
                                                                              ''
                                                                          ? 'Select Dealer'
                                                                          : selectDealer,
                                                                      style: TextStyle(
                                                                          color: selectDealer == ''
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
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.38,
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
                                        ],
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text(
                                                '3. Remark',
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.54,
                                              height: 153,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLines: 6,
                                                controller: ctrlRemark,
                                                decoration: InputDecoration(
                                                    hintText: 'Remark',
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
                        bloc: updateLoanDataBloc,
                        listener: (_, UpdateLoanDataState state) {
                          if (state is UpdateLoanDataLoading) {}
                          if (state is UpdateLoanDataLoaded) {
                            if (selectPackage != '') {
                              setState(() {
                                isPackage = true;
                              });
                            }

                            Navigator.pushNamed(context,
                                StringRouterUtil.applicationForm4ScreenTabRoute,
                                arguments: UpdateAssetRequestModel(
                                    pApplicationNo: widget
                                        .updateLoanDataRequestModel
                                        .pApplicationNo));
                          }
                          if (state is UpdateLoanDataError) {
                            GeneralUtil().showSnackBar(context, state.error!);
                          }
                          if (state is UpdateLoanDataException) {}
                        },
                        child: BlocBuilder(
                            bloc: updateLoanDataBloc,
                            builder: (_, UpdateLoanDataState state) {
                              if (state is UpdateLoanDataLoading) {
                                return const SizedBox(
                                  width: 200,
                                  height: 45,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state is UpdateLoanDataLoaded) {
                                return InkWell(
                                  onTap: () {
                                    if (ctrlRemark.text.isEmpty ||
                                        ctrlRemark.text == '' ||
                                        selectPackage == '' ||
                                        selectDealer == '') {
                                      EmptyWidget().showBottomEmpty(context);
                                    } else {
                                      updateLoanDataBloc.add(UpdateLoanDataAttempt(
                                          UpdateLoanDataRequestModel(
                                              pApplicationNo: widget
                                                  .updateLoanDataRequestModel
                                                  .pApplicationNo,
                                              pDealerCode: selectDealerCode,
                                              pMarketingCode: widget
                                                  .updateLoanDataRequestModel
                                                  .pMarketingCode,
                                              pMarketingName: widget
                                                  .updateLoanDataRequestModel
                                                  .pMarketingName,
                                              pPackageCode: selectPackageCode,
                                              pRemark: ctrlRemark.text)));
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
                                onTap: () {
                                  if (ctrlRemark.text.isEmpty ||
                                      ctrlRemark.text == '' ||
                                      selectPackage == '' ||
                                      selectDealer == '') {
                                    EmptyWidget().showBottomEmpty(context);
                                  } else {
                                    updateLoanDataBloc.add(
                                        UpdateLoanDataAttempt(
                                            UpdateLoanDataRequestModel(
                                                pApplicationNo: widget
                                                    .updateLoanDataRequestModel
                                                    .pApplicationNo,
                                                pDealerCode: selectDealerCode,
                                                pMarketingCode: widget
                                                    .updateLoanDataRequestModel
                                                    .pMarketingCode,
                                                pMarketingName: widget
                                                    .updateLoanDataRequestModel
                                                    .pMarketingName,
                                                pPackageCode: selectPackageCode,
                                                pRemark: ctrlRemark.text)));
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
