import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sales_order/features/application_form_1/domain/repo/form_1_repo.dart';
import 'package:sales_order/features/application_form_1/presentation/bloc/get_client_bloc/bloc.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_summary/domain/repo/summary_repo.dart';
import 'package:sales_order/features/application_form_summary/presentation/bloc/detail_summary_bloc/bloc.dart';

import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:signature/signature.dart';

class ApplicationFormSummaryViewTabScreen extends StatefulWidget {
  const ApplicationFormSummaryViewTabScreen(
      {super.key, required this.applicationNo});
  final String applicationNo;

  @override
  State<ApplicationFormSummaryViewTabScreen> createState() =>
      _ApplicationFormSummaryViewTabScreenState();
}

class _ApplicationFormSummaryViewTabScreenState
    extends State<ApplicationFormSummaryViewTabScreen> {
  bool check1 = true;
  bool check2 = true;
  bool isMarried = true;
  bool isDisableTtd = false;
  bool isDisableTtdSpouse = false;
  bool isLoading = true;
  DetailSummaryBloc detailSummaryBloc =
      DetailSummaryBloc(summaryRepo: SummaryRepo());
  GetClientBloc getClientBloc = GetClientBloc(form1repo: Form1Repo());
  double tdpAmount = 0.0;
  double installmentAmount = 0.0;
  String dueDate = '';

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    onDrawStart: () => log('onDrawStart called!'),
    onDrawEnd: () => log('onDrawEnd called!'),
  );

  final SignatureController _controllerSpouse = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    onDrawStart: () => log('onDrawStart called!'),
    onDrawEnd: () => log('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => log('Value changed'));
    _controllerSpouse.addListener(() => log('Value changed'));
    detailSummaryBloc.add(DetailSummaryAttempt(widget.applicationNo));
    getClientBloc.add(GetClientAttempt(widget.applicationNo));
  }

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    _controller.dispose();
    _controllerSpouse.dispose();
    super.dispose();
  }

  Future<void> exportImage(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data =
        await _controller.toPngBytes(height: 1000, width: 1000);
    if (data == null) {
      return;
    }

    if (!mounted) return;

    // await push(
    //   context,
    //   Scaffold(
    //     appBar: AppBar(
    //       title: const Text('PNG Image'),
    //     ),
    //     body: Center(
    //       child: Container(
    //         color: Colors.grey[300],
    //         child: Image.memory(data),
    //       ),
    //     ),
    //   ),
    // );
  }

  Future<void> exportSVG(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarSVG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final SvgPicture data = _controller.toSVG()!;

    if (!mounted) return;

    // await push(
    //   context,
    //   Scaffold(
    //     appBar: AppBar(
    //       title: const Text('SVG Image'),
    //     ),
    //     body: Center(
    //       child: Container(
    //         color: Colors.grey[300],
    //         child: data,
    //       ),
    //     ),
    //   ),
    // );
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
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                child: const Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Text(
                    'Summary',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.72,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 80.0, right: 80.0, top: 8.0),
                      child: MultiBlocListener(
                          listeners: [
                            BlocListener(
                              bloc: getClientBloc,
                              listener: (_, GetClientState state) {
                                if (state is GetClientLoading) {}
                                if (state is GetClientLoaded) {
                                  if (state.clientDetailResponseModel.data![0]
                                          .clientMaritalStatusType !=
                                      'MARRIED') {
                                    setState(() {
                                      isMarried = false;
                                      isLoading = false;
                                    });
                                  }
                                }
                                if (state is GetClientError) {
                                  GeneralUtil()
                                      .showSnackBar(context, state.error!);
                                }
                                if (state is GetClientException) {}
                              },
                            ),
                            BlocListener(
                              bloc: detailSummaryBloc,
                              listener: (_, DetailSummaryState state) async {
                                if (state is DetailSummaryLoading) {}
                                if (state is DetailSummaryLoaded) {
                                  setState(() {
                                    dueDate = state.detailSummaryResponseModel
                                        .data![0].dueDate
                                        .toString();
                                    installmentAmount = state
                                        .detailSummaryResponseModel
                                        .data![0]
                                        .installmentAmount!;
                                    tdpAmount = state.detailSummaryResponseModel
                                        .data![0].installmentAmount!;
                                  });
                                }
                                if (state is DetailSummaryError) {
                                  GeneralUtil()
                                      .showSnackBar(context, state.error!);
                                }
                                if (state is DetailSummaryException) {}
                              },
                            )
                          ],
                          child: isLoading
                              ? _loading()
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'TDP',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              width: 300,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.1)),
                                                color: const Color(0xFFFAF9F9),
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
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  GeneralUtil.convertToIdr(
                                                      tdpAmount, 2),
                                                  style: const TextStyle(
                                                      color: Color(0xFF6E6E6E),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Installment Amount',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              width: 300,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.1)),
                                                color: const Color(0xFFFAF9F9),
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
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  GeneralUtil.convertToIdr(
                                                      installmentAmount, 2),
                                                  style: const TextStyle(
                                                      color: Color(0xFF6E6E6E),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Due Date',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              width: 300,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.1)),
                                                color: const Color(0xFFFAF9F9),
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
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  dueDate,
                                                  style: const TextStyle(
                                                      color: Color(0xFF6E6E6E),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                            activeColor: primaryColor,
                                            value: check1,
                                            onChanged: (newValue) {
                                              // setState(() {
                                              //   check1 = newValue!;
                                              // });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Text(
                                          'Saya menyetujui untuk mengajukan permohonan kredit serta memperbolehkan data saya untuk diproses lebih lanjut sebagai syarat proses pengajuan kredit di IMS Finance.',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color(0xFF222222),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'TTD',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Stack(
                                              children: [
                                                Material(
                                                  elevation: 6,
                                                  shadowColor: Colors.grey
                                                      .withOpacity(0.4),
                                                  child: AbsorbPointer(
                                                    absorbing: true,
                                                    child: Signature(
                                                      key: const Key(
                                                          'signature'),
                                                      controller: _controller,
                                                      height: 200,
                                                      width: 500,
                                                      backgroundColor:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 8,
                                                  bottom: 8,
                                                  child: Row(
                                                    children: const [],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            isMarried
                                                ? const Text(
                                                    'TTD Spouse',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Container(),
                                            const SizedBox(height: 8),
                                            isMarried
                                                ? Stack(
                                                    children: [
                                                      Material(
                                                        elevation: 6,
                                                        shadowColor: Colors.grey
                                                            .withOpacity(0.4),
                                                        child: AbsorbPointer(
                                                          absorbing: true,
                                                          child: Signature(
                                                            key: const Key(
                                                                'signature'),
                                                            controller:
                                                                _controllerSpouse,
                                                            height: 200,
                                                            width: 500,
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: 8,
                                                        bottom: 8,
                                                        child: Row(
                                                          children: const [],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )))),
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
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            StringRouterUtil.tabScreenTabRoute,
                            (route) => false);
                      },
                      child: Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: thirdColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child: Text('CLOSE',
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
        ));
  }

  Widget _loading() {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.55,
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
          children: List.generate(16, (int index) {
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
