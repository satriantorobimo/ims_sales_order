import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/cancel_widget.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/option_widget.dart';
import 'package:sales_order/features/application_form_7/data/document_delete_request_model.dart';
import 'package:sales_order/features/application_form_7/data/document_list_response_model.dart';
import 'package:sales_order/features/application_form_7/data/document_preview_request_model.dart';
import 'package:sales_order/features/application_form_7/data/document_update_request_model.dart';
import 'package:sales_order/features/application_form_7/data/document_upload_request_model.dart';
import 'package:sales_order/features/application_form_7/domain/repo/form_7_repo.dart';
import 'package:sales_order/features/application_form_7/presentation/screen/bloc/doc_delete_bloc/bloc.dart';
import 'package:sales_order/features/application_form_7/presentation/screen/bloc/doc_list_bloc/bloc.dart';
import 'package:sales_order/features/application_form_7/presentation/screen/bloc/doc_preview_bloc/bloc.dart';
import 'package:sales_order/features/application_form_7/presentation/screen/bloc/doc_update_bloc/bloc.dart';
import 'package:sales_order/features/application_form_7/presentation/screen/bloc/doc_upload_bloc/bloc.dart';
import 'package:sales_order/features/application_form_7/presentation/widget/empty_doc_widget.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:path/path.dart' as path;
import 'package:shimmer/shimmer.dart';

class ApplicationForm7ViewMobileScreen extends StatefulWidget {
  const ApplicationForm7ViewMobileScreen(
      {super.key, required this.applicationNo});
  final String applicationNo;

  @override
  State<ApplicationForm7ViewMobileScreen> createState() =>
      _ApplicationForm7ViewMobileScreenState();
}

class _ApplicationForm7ViewMobileScreenState
    extends State<ApplicationForm7ViewMobileScreen> {
  bool isLoading = true;
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
            'Document',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener(
              bloc: docListBloc,
              listener: (_, DocListState state) {
                if (state is DocListLoading) {}
                if (state is DocListLoaded) {
                  setState(() {
                    dataFilter = state.documentListResponseModel.data!;
                    data.addAll(state.documentListResponseModel.data!);
                    isLoading = false;
                  });
                }
                if (state is DocListError) {
                  GeneralUtil().showSnackBar(context, state.error!);
                }
                if (state is DocListException) {}
              },
            ),
          ],
          child: isLoading
              ? _loading()
              : ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  itemCount: dataFilter.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Container(
                        width: double.infinity,
                        height: 8,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var promDate = '';
                    var expDate = '';
                    var effDate = '';
                    if (dataFilter[index].expiredDate != null) {
                      DateTime tempExpDate = DateFormat('yyyy-MM-dd')
                          .parse(dataFilter[index].expiredDate!);
                      var inputExpDate = DateTime.parse(tempExpDate.toString());
                      var outputExpFormat = DateFormat('dd/MM/yyyy');
                      expDate = outputExpFormat.format(inputExpDate);
                    }

                    if (dataFilter[index].promiseDate != null) {
                      DateTime tempPromDate = DateFormat('yyyy-MM-dd')
                          .parse(dataFilter[index].promiseDate!);
                      var inputPromDate =
                          DateTime.parse(tempPromDate.toString());
                      var outputPromFormat = DateFormat('dd/MM/yyyy');
                      promDate = outputPromFormat.format(inputPromDate);
                    }

                    if (dataFilter[index].effectiveDate != null) {
                      DateTime tempPromDate = DateFormat('yyyy-MM-dd')
                          .parse(dataFilter[index].effectiveDate!);
                      var inputPromDate =
                          DateTime.parse(tempPromDate.toString());
                      var outputPromFormat = DateFormat('dd/MM/yyyy');
                      effDate = outputPromFormat.format(inputPromDate);
                    }
                    final ext = path.extension(dataFilter[index].filename!);
                    final fp = path.extension(dataFilter[index].paths!);
                    if (index == dataFilter.length - 1) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
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
                                          .applicationFormSummaryViewScreenMobileRoute,
                                      arguments: widget.applicationNo);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
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
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    dataFilter[index].docSource ==
                                            'CLIENT_DOCUMENT'
                                        ? 'Document Client'
                                        : dataFilter[index].docSource ==
                                                'APPLICATION_ASSET_DOCUMENT'
                                            ? 'Document Asset Application'
                                            : 'Document Application',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  dataFilter[index].isRequired == '1'
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
                              Container(
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
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
                                    '${dataFilter[index].docName}',
                                    style: const TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              dataFilter[index].docSource == 'CLIENT_DOCUMENT'
                                  ? InkWell(
                                      onTap: null,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Effective Date',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.1)),
                                              color: const Color(0xFFFAF9F9),
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
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                effDate,
                                                style: const TextStyle(
                                                    color: Color(0xFF6E6E6E),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : InkWell(
                                      onTap: null,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Promise Date',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.1)),
                                              color: const Color(0xFFFAF9F9),
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
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                promDate,
                                                style: const TextStyle(
                                                    color: Color(0xFF6E6E6E),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                              InkWell(
                                onTap: null,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Expired Date',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.1)),
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
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          expDate,
                                          style: const TextStyle(
                                              color: Color(0xFF6E6E6E),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'File',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: dataFilter[index].paths == ""
                                    ? null
                                    : () async {
                                        if (dataFilter[index].isNew!) {
                                          if (ext == '.pdf') {
                                            await OpenFile.open(
                                                "${dataFilter[index].paths}");
                                          } else {
                                            Navigator.pushNamed(
                                                context,
                                                StringRouterUtil
                                                    .applicationForm7PreviewAssetScreenTabRoute,
                                                arguments:
                                                    dataFilter[index].paths);
                                          }
                                        } else {
                                          if (ext == '.PDF') {
                                            Navigator.pushNamed(
                                                context,
                                                StringRouterUtil
                                                    .applicationForm7PreviewPdfScreenTabRoute,
                                                arguments:
                                                    DocumentPreviewRequestModel(
                                                        pFileName:
                                                            dataFilter[index]
                                                                .filename,
                                                        pFilePaths:
                                                            dataFilter[index]
                                                                .paths));
                                          } else {
                                            Navigator.pushNamed(
                                                context,
                                                StringRouterUtil
                                                    .applicationForm7PreviewScreenTabRoute,
                                                arguments:
                                                    DocumentPreviewRequestModel(
                                                        pFileName:
                                                            dataFilter[index]
                                                                .filename,
                                                        pFilePaths:
                                                            dataFilter[index]
                                                                .paths));
                                          }
                                        }
                                      },
                                child: Container(
                                  height: 35,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: dataFilter[index].paths == ""
                                        ? const Color(0xFFE1E1E1)
                                        : primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                      child: Text(
                                          dataFilter[index].paths == ""
                                              ? 'CHOOSE FILE'
                                              : 'VIEW FILE',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600))),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
        ));
  }

  Widget _loading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
          shrinkWrap: true,
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
              height: MediaQuery.of(context).size.width * 0.45,
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
