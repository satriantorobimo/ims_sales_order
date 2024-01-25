import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_7/data/document_list_response_model.dart';
import 'package:sales_order/features/application_form_7/data/document_preview_request_model.dart';
import 'package:sales_order/features/application_form_7/domain/repo/form_7_repo.dart';
import 'package:sales_order/features/application_form_7/presentation/screen/bloc/doc_list_bloc/bloc.dart';
import 'package:sales_order/features/application_form_7/presentation/screen/bloc/doc_preview_bloc/bloc.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:path/path.dart' as path;

class ApplicationForm7ViewTabScreen extends StatefulWidget {
  const ApplicationForm7ViewTabScreen({super.key, required this.applicationNo});
  final String applicationNo;

  @override
  State<ApplicationForm7ViewTabScreen> createState() =>
      _ApplicationForm7ViewTabScreenState();
}

class _ApplicationForm7ViewTabScreenState
    extends State<ApplicationForm7ViewTabScreen> {
  var selectedPageNumber = 0;
  var pagination = 0;
  var length = 0;
  final int _perPage = 5;
  DocListBloc docListBloc = DocListBloc(form7repo: Form7Repo());
  DocPreviewBloc docPreviewBloc = DocPreviewBloc(form7repo: Form7Repo());
  List<Data> data = [];
  late List<Data> dataFilter = [];
  int count = 0;

  @override
  void initState() {
    docListBloc.add(DocListAttempt(widget.applicationNo));
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
                                color: Colors.white,
                              )
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
                height: MediaQuery.of(context).size.height * 0.65,
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 80.0, right: 80.0, top: 8.0),
                    child: BlocListener(
                        bloc: docListBloc,
                        listener: (_, DocListState state) {
                          if (state is DocListLoading) {}
                          if (state is DocListLoaded) {
                            setState(() {
                              pagination = (state.documentListResponseModel
                                          .data!.length /
                                      5)
                                  .ceil();
                              length =
                                  state.documentListResponseModel.data!.length;
                              if (pagination == 1) {
                                dataFilter =
                                    state.documentListResponseModel.data!;
                              } else {
                                dataFilter = state
                                    .documentListResponseModel.data!
                                    .sublist(
                                        (selectedPageNumber * _perPage),
                                        ((selectedPageNumber * _perPage) +
                                            _perPage));
                              }
                              data.addAll(
                                  state.documentListResponseModel.data!);
                            });
                          }
                          if (state is DocListError) {
                            GeneralUtil().showSnackBar(context, state.error!);
                          }
                          if (state is DocListException) {}
                        },
                        child: BlocBuilder(
                            bloc: docListBloc,
                            builder: (_, DocListState state) {
                              if (state is DocListLoading) {}
                              if (state is DocListLoaded) {
                                return ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    itemCount: dataFilter.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(height: 10);
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var promDate = '-';
                                      var expDate = '-';
                                      var effDate = '';
                                      if (dataFilter[index].expiredDate !=
                                          null) {
                                        DateTime tempExpDate =
                                            DateFormat('yyyy-MM-dd').parse(
                                                dataFilter[index].expiredDate!);
                                        var inputExpDate = DateTime.parse(
                                            tempExpDate.toString());
                                        var outputExpFormat =
                                            DateFormat('dd/MM/yyyy');
                                        expDate = outputExpFormat
                                            .format(inputExpDate);
                                      }

                                      if (dataFilter[index].promiseDate !=
                                          null) {
                                        DateTime tempPromDate =
                                            DateFormat('yyyy-MM-dd').parse(
                                                dataFilter[index].promiseDate!);
                                        var inputPromDate = DateTime.parse(
                                            tempPromDate.toString());
                                        var outputPromFormat =
                                            DateFormat('dd/MM/yyyy');
                                        promDate = outputPromFormat
                                            .format(inputPromDate);
                                      }
                                      if (dataFilter[index].effectiveDate !=
                                          null) {
                                        DateTime tempPromDate =
                                            DateFormat('yyyy-MM-dd').parse(
                                                dataFilter[index]
                                                    .effectiveDate!);
                                        var inputPromDate = DateTime.parse(
                                            tempPromDate.toString());
                                        var outputPromFormat =
                                            DateFormat('dd/MM/yyyy');
                                        effDate = outputPromFormat
                                            .format(inputPromDate);
                                      }
                                      final ext = path.extension(state
                                          .documentListResponseModel
                                          .data![index]
                                          .filename!);
                                      final fp = path
                                          .extension(dataFilter[index].paths!);
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    dataFilter[index]
                                                                .docSource ==
                                                            'CLIENT_DOCUMENT'
                                                        ? 'Document Client'
                                                        : dataFilter[index]
                                                                    .docSource ==
                                                                'APPLICATION_ASSET_DOCUMENT'
                                                            ? 'Document Asset Application'
                                                            : 'Document Application',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  dataFilter[index]
                                                              .isRequired ==
                                                          '1'
                                                      ? const Text(
                                                          ' *',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                width: 410,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '${dataFilter[index].docName}',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF333333),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 130,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'File',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap:
                                                      dataFilter[index].paths ==
                                                              ""
                                                          ? null
                                                          : () {
                                                              if (ext ==
                                                                  '.PDF') {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    StringRouterUtil
                                                                        .applicationForm7PreviewPdfScreenTabRoute,
                                                                    arguments: DocumentPreviewRequestModel(
                                                                        pFileName:
                                                                            dataFilter[index]
                                                                                .filename,
                                                                        pFilePaths:
                                                                            dataFilter[index].paths));
                                                              } else {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    StringRouterUtil
                                                                        .applicationForm7PreviewScreenTabRoute,
                                                                    arguments: DocumentPreviewRequestModel(
                                                                        pFileName:
                                                                            dataFilter[index]
                                                                                .filename,
                                                                        pFilePaths:
                                                                            dataFilter[index].paths));
                                                              }
                                                            },
                                                  child: Container(
                                                    height: 50,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration: BoxDecoration(
                                                      color: dataFilter[index]
                                                                  .paths ==
                                                              ""
                                                          ? Colors.grey
                                                          : primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Center(
                                                        child: Text('VIEW FILE',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600))),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                              ],
                                            ),
                                          ),
                                          dataFilter[index].docSource ==
                                                  'CLIENT_DOCUMENT'
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Effective Date',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Container(
                                                      width: 130,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1)),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
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
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16.0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          effDate,
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFF333333),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Promise Date',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Container(
                                                      width: 130,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1)),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
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
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16.0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          promDate,
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFF333333),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
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
                                                'Expired Date',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                width: 130,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    expDate,
                                                    style: const TextStyle(
                                                        color: Colors.black,
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
                                            children: const [
                                              Text(
                                                'Action',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 8),
                                              SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons
                                                          .delete_outline_rounded,
                                                      color: Colors.grey,
                                                      size: 45,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ],
                                      );
                                    });
                              }
                              return Container();
                            }))),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 35,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    selectedPageNumber == 0
                        ? const Icon(
                            Icons.keyboard_arrow_left_rounded,
                            size: 32,
                            color: Colors.grey,
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                selectedPageNumber--;
                                if (selectedPageNumber == pagination - 1) {
                                  dataFilter = data.sublist(
                                      (selectedPageNumber * _perPage), length);
                                } else {
                                  dataFilter = data.sublist(
                                      (selectedPageNumber * _perPage),
                                      ((selectedPageNumber * _perPage) +
                                          _perPage));
                                }
                              });
                            },
                            child: const Icon(Icons.keyboard_arrow_left_rounded,
                                size: 32)),
                    ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: pagination,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(width: 4);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedPageNumber = index;
                                try {
                                  if (selectedPageNumber == pagination - 1) {
                                    dataFilter = data.sublist(
                                        (selectedPageNumber * _perPage),
                                        length);
                                  } else {
                                    dataFilter = data.sublist(
                                        (selectedPageNumber * _perPage),
                                        ((selectedPageNumber * _perPage) +
                                            _perPage));
                                  }
                                } catch (e) {
                                  log(e.toString());
                                }
                              });
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: selectedPageNumber == index
                                      ? primaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: selectedPageNumber == index
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          );
                        }),
                    selectedPageNumber == pagination - 1
                        ? const Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 32,
                            color: Colors.grey,
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                selectedPageNumber++;
                                if (selectedPageNumber == pagination - 1) {
                                  dataFilter = data.sublist(
                                      (selectedPageNumber * _perPage), length);
                                } else {
                                  dataFilter = data.sublist(
                                      (selectedPageNumber * _perPage),
                                      ((selectedPageNumber * _perPage) +
                                          _perPage));
                                }
                              });
                            },
                            child: const Icon(
                              Icons.keyboard_arrow_right_rounded,
                              size: 32,
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
                      onTap: () async {
                        Navigator.pushNamed(
                            context,
                            StringRouterUtil
                                .applicationFormSummaryViewScreenTabRoute,
                            arguments: widget.applicationNo);
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
