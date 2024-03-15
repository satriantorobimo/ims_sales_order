import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_3/domain/repo/form_3_repo.dart';
import 'package:sales_order/features/application_form_3/presentation/bloc/loan_data_detail_bloc/bloc.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class ApplicationForm3ViewMobileScreen extends StatefulWidget {
  const ApplicationForm3ViewMobileScreen(
      {super.key, required this.applicationNo});
  final String applicationNo;

  @override
  State<ApplicationForm3ViewMobileScreen> createState() =>
      _ApplicationForm3ViewMobileScreenState();
}

class _ApplicationForm3ViewMobileScreenState
    extends State<ApplicationForm3ViewMobileScreen> {
  int selectIndexPackage = 0;
  String selectPackage = '';
  String selectPackageCode = '';
  int selectIndexDealer = 0;
  String selectDealer = '';
  String selectDealerCode = '';
  LoanDataDetailBloc loanDataDetailBloc =
      LoanDataDetailBloc(form3repo: Form3Repo());
  TextEditingController ctrlRemark = TextEditingController();

  @override
  void initState() {
    loanDataDetailBloc.add(LoanDataDetailAttempt(widget.applicationNo));
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
                if (state.loanDataDetailResponseModel.data![0]
                        .applicationRemarks !=
                    null) {
                  ctrlRemark.text = state
                      .loanDataDetailResponseModel.data![0].applicationRemarks!;
                }
                if (state.loanDataDetailResponseModel.data![0].packageCode !=
                    null) {
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
              });
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
                                    selectPackage,
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
                                    selectDealer,
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
                                    readOnly: true,
                                    maxLines: 6,
                                    controller: ctrlRemark,
                                    style: const TextStyle(
                                        color: Color(0xFF6E6E6E)),
                                    decoration: InputDecoration(
                                        hintText: 'Remark',
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
                                            .applicationForm4ViewScreenMobileRoute,
                                        arguments: widget.applicationNo);
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
                                )
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
