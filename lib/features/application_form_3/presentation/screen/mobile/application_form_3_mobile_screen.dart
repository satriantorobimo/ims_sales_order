import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/empty_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
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
import 'package:sales_order/features/application_form_3/data/look_up_dealer_model.dart'
    as dealer;
import 'package:sales_order/features/application_form_3/data/look_up_package_model.dart'
    as package;
import 'package:shimmer/shimmer.dart';

class ApplicationForm3MobileScreen extends StatefulWidget {
  const ApplicationForm3MobileScreen(
      {super.key, required this.updateLoanDataRequestModel});
  final UpdateLoanDataRequestModel updateLoanDataRequestModel;

  @override
  State<ApplicationForm3MobileScreen> createState() =>
      _ApplicationForm3MobileScreenState();
}

class _ApplicationForm3MobileScreenState
    extends State<ApplicationForm3MobileScreen> {
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
                      padding: EdgeInsets.only(top: 16.0, left: 8, right: 8),
                      child: Text(
                        'Package',
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
                              left: 16, right: 16, bottom: 16),
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
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      tempList.isNotEmpty
                                          ? tempList[index].packageDescription!
                                          : lookUpPackageModel
                                              .data![index].packageDescription!,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
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
                      padding: EdgeInsets.only(top: 16.0, left: 8, right: 8),
                      child: Text(
                        'Dealer',
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
                              left: 16, right: 16, bottom: 16),
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
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      tempList.isNotEmpty
                                          ? tempList[index].vendorName!
                                          : lookUpDealerModel
                                              .data![index].vendorName!,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
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
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'Loan Data',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocListener(
          bloc: loanDataDetailBloc,
          listener: (_, LoanDataDetailState state) {
            if (state is LoanDataDetailLoading) {}
            if (state is LoanDataDetailLoaded) {
              setState(() {
                if (state.loanDataDetailResponseModel.data![0].packageCode !=
                    null) {
                  isPackage = true;
                  selectPackageCode =
                      state.loanDataDetailResponseModel.data![0].packageCode!;
                  selectPackage = state
                      .loanDataDetailResponseModel.data![0].packageDescription!;
                }
                if (state.loanDataDetailResponseModel.data![0].vendorCode !=
                    null) {
                  selectDealerCode =
                      state.loanDataDetailResponseModel.data![0].vendorCode!;
                  selectDealer =
                      state.loanDataDetailResponseModel.data![0].vendorName!;
                }
                if (state.loanDataDetailResponseModel.data![0]
                        .applicationRemarks !=
                    null) {
                  ctrlRemark.text = state
                      .loanDataDetailResponseModel.data![0].applicationRemarks!;
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
                                    'Package',
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
                                      bloc: packageBloc,
                                      listener: (_, PackageState state) {
                                        if (state is PackageLoading) {}
                                        if (state is PackageLoaded) {
                                          setState(() {
                                            selectIndexPackage = 1000;
                                          });
                                        }
                                        if (state is PackageError) {}
                                        if (state is PackageException) {}
                                      },
                                      child: BlocBuilder(
                                          bloc: packageBloc,
                                          builder: (_, PackageState state) {
                                            if (state is PackageLoading) {}
                                            if (state is PackageLoaded) {
                                              return InkWell(
                                                onTap: isPackage
                                                    ? null
                                                    : () {
                                                        _showBottom(state
                                                            .lookUpPackageModel);
                                                      },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.1)),
                                                    color: isPackage
                                                        ? const Color(
                                                            0xFFFAF9F9)
                                                        : Colors.white,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.78,
                                                      child: Text(
                                                        selectPackage == ''
                                                            ? 'Select Package'
                                                            : selectPackage,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: selectPackage ==
                                                                    ''
                                                                ? Colors.grey
                                                                    .withOpacity(
                                                                        0.5)
                                                                : isPackage
                                                                    ? const Color(
                                                                        0xFF6E6E6E)
                                                                    : Colors
                                                                        .black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
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
                                                  left: 16.0, right: 16.0),
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
                                  Positioned(
                                    right: 16,
                                    child: isPackage
                                        ? Container()
                                        : const Icon(
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
                                    'Dealer',
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
                                      bloc: dealerBloc,
                                      listener: (_, DealerState state) {
                                        if (state is DealerLoading) {}
                                        if (state is DealerLoaded) {
                                          setState(() {
                                            selectIndexDealer = 1000;
                                          });
                                        }
                                        if (state is DealerError) {}
                                        if (state is DealerException) {}
                                      },
                                      child: BlocBuilder(
                                          bloc: dealerBloc,
                                          builder: (_, DealerState state) {
                                            if (state is DealerLoading) {}
                                            if (state is DealerLoaded) {
                                              return InkWell(
                                                onTap: () {
                                                  _showBottomDealer(
                                                      state.lookUpDealerModel);
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      selectDealer == ''
                                                          ? 'Select Dealer'
                                                          : selectDealer,
                                                      style: TextStyle(
                                                          color: selectDealer ==
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
                                                    offset: const Offset(-6,
                                                        4), // Shadow position
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
                                                      fontWeight:
                                                          FontWeight.w400),
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
                                    'Remark',
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
                                    keyboardType: TextInputType.text,
                                    maxLines: 6,
                                    controller: ctrlRemark,
                                    decoration: InputDecoration(
                                        hintText: 'Remark',
                                        isDense: true,
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

                                        Navigator.pushNamed(
                                            context,
                                            StringRouterUtil
                                                .applicationForm4ScreenMobileRoute,
                                            arguments: UpdateAssetRequestModel(
                                                pApplicationNo: widget
                                                    .updateLoanDataRequestModel
                                                    .pApplicationNo));
                                      }
                                      if (state is UpdateLoanDataError) {
                                        GeneralUtil().showSnackBar(
                                            context, state.error!);
                                      }
                                      if (state is UpdateLoanDataException) {}
                                    },
                                    child: BlocBuilder(
                                        bloc: updateLoanDataBloc,
                                        builder:
                                            (_, UpdateLoanDataState state) {
                                          if (state is UpdateLoanDataLoading) {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              height: 45,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
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
                                                  EmptyWidget()
                                                      .showBottomEmpty(context);
                                                } else {
                                                  updateLoanDataBloc.add(UpdateLoanDataAttempt(
                                                      UpdateLoanDataRequestModel(
                                                          pApplicationNo: widget
                                                              .updateLoanDataRequestModel
                                                              .pApplicationNo,
                                                          pDealerCode:
                                                              selectDealerCode,
                                                          pMarketingCode: widget
                                                              .updateLoanDataRequestModel
                                                              .pMarketingCode,
                                                          pMarketingName: widget
                                                              .updateLoanDataRequestModel
                                                              .pMarketingName,
                                                          pPackageCode:
                                                              selectPackageCode,
                                                          pRemark: ctrlRemark
                                                              .text)));
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  color: thirdColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Center(
                                                    child: Text('NEXT',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                              ),
                                            );
                                          }
                                          return InkWell(
                                            onTap: () {
                                              if (ctrlRemark.text.isEmpty ||
                                                  ctrlRemark.text == '' ||
                                                  selectPackage == '' ||
                                                  selectDealer == '') {
                                                EmptyWidget()
                                                    .showBottomEmpty(context);
                                              } else {
                                                updateLoanDataBloc.add(UpdateLoanDataAttempt(
                                                    UpdateLoanDataRequestModel(
                                                        pApplicationNo: widget
                                                            .updateLoanDataRequestModel
                                                            .pApplicationNo,
                                                        pDealerCode:
                                                            selectDealerCode,
                                                        pMarketingCode: widget
                                                            .updateLoanDataRequestModel
                                                            .pMarketingCode,
                                                        pMarketingName: widget
                                                            .updateLoanDataRequestModel
                                                            .pMarketingName,
                                                        pPackageCode:
                                                            selectPackageCode,
                                                        pRemark:
                                                            ctrlRemark.text)));
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: thirdColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Center(
                                                  child: Text('NEXT',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .w600))),
                                            ),
                                          );
                                        })),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
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
