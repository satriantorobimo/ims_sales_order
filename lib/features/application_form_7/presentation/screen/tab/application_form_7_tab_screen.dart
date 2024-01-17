// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_form_1/presentation/widget/cancel_widget.dart';
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

class ApplicationForm7TabScreen extends StatefulWidget {
  const ApplicationForm7TabScreen({super.key, required this.applicationNo});
  final String applicationNo;

  @override
  State<ApplicationForm7TabScreen> createState() =>
      _ApplicationForm7TabScreenState();
}

class _ApplicationForm7TabScreenState extends State<ApplicationForm7TabScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  var selectedPageNumber = 0;
  var pagination = 0;
  var length = 0;
  final int _perPage = 5;
  DocListBloc docListBloc = DocListBloc(form7repo: Form7Repo());
  DocPreviewBloc docPreviewBloc = DocPreviewBloc(form7repo: Form7Repo());
  DocUploadBloc docUploadBloc = DocUploadBloc(form7repo: Form7Repo());
  DocDeleteBloc docDeleteBloc = DocDeleteBloc(form7repo: Form7Repo());
  DocUpdateBloc docUpdateBloc = DocUpdateBloc(form7repo: Form7Repo());
  late List<Data> data = [];
  late List<Data> dataFilter = [];
  int count = 0;
  bool isLoading = false;
  bool noPic = false;

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController!.repeat();
    docListBloc.add(DocListAttempt(widget.applicationNo));
    super.initState();
  }

  Future<void> _showBottomAttachment(int index, id) {
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
                    'Select Recource File',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        pickImage('camera', index, id);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.camera_alt_rounded, size: 18),
                          SizedBox(width: 16),
                          Text(
                            'Camera',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        pickImage('gallery', index, id);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.folder_rounded, size: 18),
                          SizedBox(width: 16),
                          Text(
                            'File',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 24),
              ],
            ),
          );
        });
  }

  Future<bool> pickImage(String type, int index, int id) async {
    try {
      var maxFileSizeInBytes = 5 * 1048576;
      ImagePicker imagePicker = ImagePicker();
      XFile? pickedImage = await imagePicker.pickImage(
        source: type == 'gallery' ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 90,
      );
      if (pickedImage == null) return false;
      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length; // Get the file size in bytes
      if (fileSize <= maxFileSizeInBytes) {
        String basename = path.basename(pickedImage.path);
        int indexes = data.indexWhere((element) => element.id == id);
        log('${data[indexes].isNew}');
        setState(() {
          dataFilter[index].paths = pickedImage.path;
          dataFilter[index].filename = basename;
          dataFilter[index].isNew = true;
          data[indexes].filename = basename;
          data[indexes].paths = pickedImage.path;
          data[indexes].isNew = true;
        });
        log('${data[indexes].isNew}');
      } else {
        return false;
      }

      return true;
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
      return false;
    }
  }

  void _promDatePicker(int index) {
    showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 90)),
            firstDate: DateTime.now())
        .then((pickedDate) {
      int indexes =
          data.indexWhere((element) => element.id == dataFilter[index].id);
      if (pickedDate == null) {
        return;
      }
      setState(() {
        dataFilter[index].promiseDate =
            DateFormat('yyyy-MM-dd').format(pickedDate);
        data[indexes].promiseDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    });
  }

  void _expDatePicker(int index) {
    showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 15000)),
            firstDate: DateTime.now())
        .then((pickedDate) {
      int indexes =
          data.indexWhere((element) => element.id == dataFilter[index].id);
      if (pickedDate == null) {
        return;
      }
      setState(() {
        dataFilter[index].expiredDate =
            DateFormat('yyyy-MM-dd').format(pickedDate);
        data[indexes].expiredDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    });
  }

  void _effDatePicker(int index) {
    showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: DateTime.now(),
            lastDate: DateTime.now(),
            firstDate: DateTime.now().add(const Duration(days: -15000)))
        .then((pickedDate) {
      int indexes =
          data.indexWhere((element) => element.id == dataFilter[index].id);
      if (pickedDate == null) {
        return;
      }
      setState(() {
        dataFilter[index].effectiveDate =
            DateFormat('yyyy-MM-dd').format(pickedDate);
        data[indexes].effectiveDate =
            DateFormat('yyyy-MM-dd').format(pickedDate);
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
                    CancelWidget()
                        .showBottomCancel(context, widget.applicationNo);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.redAccent,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
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
                    child: MultiBlocListener(
                      listeners: [
                        BlocListener(
                          bloc: docListBloc,
                          listener: (_, DocListState state) {
                            if (state is DocListLoading) {}
                            if (state is DocListLoaded) {
                              setState(() {
                                setState(() {
                                  pagination = (state.documentListResponseModel
                                              .data!.length /
                                          5)
                                      .ceil();
                                  length = state
                                      .documentListResponseModel.data!.length;
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
                              });
                            }
                            if (state is DocListError) {
                              GeneralUtil().showSnackBar(context, state.error!);
                            }
                            if (state is DocListException) {}
                          },
                        ),
                        BlocListener(
                          bloc: docDeleteBloc,
                          listener: (_, DocDeleteState state) {
                            if (state is DocDeleteLoaded) {
                              docListBloc
                                  .add(DocListAttempt(widget.applicationNo));
                            }
                            if (state is DocDeleteError) {
                              GeneralUtil().showSnackBar(context, state.error!);
                            }
                            if (state is DocDeleteException) {
                              GeneralUtil().showSnackBar(
                                  context, 'Terjadi Kesalahan Sistem Delete');
                            }
                          },
                        )
                      ],
                      child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemCount: dataFilter.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 16);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            var promDate = '';
                            var expDate = '';
                            var effDate = '';
                            if (dataFilter[index].expiredDate != null) {
                              DateTime tempExpDate = DateFormat('yyyy-MM-dd')
                                  .parse(dataFilter[index].expiredDate!);
                              var inputExpDate =
                                  DateTime.parse(tempExpDate.toString());
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
                            final ext =
                                path.extension(dataFilter[index].filename!);
                            final fp = path.extension(dataFilter[index].paths!);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Document',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        dataFilter[index].isRequired == '1'
                                            ? const Text(
                                                ' *',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: 410,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.1)),
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
                                        child: Row(
                                          children: [
                                            Text(
                                              '${dataFilter[index].docName}',
                                              style: const TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap: dataFilter[index].paths == ""
                                            ? () {
                                                _showBottomAttachment(index,
                                                    dataFilter[index].id);
                                              }
                                            : () {
                                                if (ext == '.PDF') {
                                                  Navigator.pushNamed(
                                                      context,
                                                      StringRouterUtil
                                                          .applicationForm7PreviewPdfScreenTabRoute,
                                                      arguments:
                                                          DocumentPreviewRequestModel(
                                                              pFileName:
                                                                  dataFilter[
                                                                          index]
                                                                      .filename,
                                                              pFilePaths:
                                                                  dataFilter[
                                                                          index]
                                                                      .paths));
                                                } else {
                                                  Navigator.pushNamed(
                                                      context,
                                                      StringRouterUtil
                                                          .applicationForm7PreviewScreenTabRoute,
                                                      arguments:
                                                          DocumentPreviewRequestModel(
                                                              pFileName:
                                                                  dataFilter[
                                                                          index]
                                                                      .filename,
                                                              pFilePaths:
                                                                  dataFilter[
                                                                          index]
                                                                      .paths));
                                                }
                                              },
                                        child: Container(
                                          height: 50,
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: Text(
                                                  dataFilter[index].paths == ""
                                                      ? 'CHOOSE FILE'
                                                      : 'VIEW FILE',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                dataFilter[index].docSource == 'CLIENT_DOCUMENT'
                                    ? InkWell(
                                        onTap: () {
                                          _effDatePicker(index);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Effective Date',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
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
                                                  effDate,
                                                  style: const TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          _promDatePicker(index);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Promise Date',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
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
                                                  promDate,
                                                  style: const TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                InkWell(
                                  onTap: () {
                                    _expDatePicker(index);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Expired Date',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 130,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.1)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
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
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                actionDelete(index),
                              ],
                            );
                          }),
                    )),
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
                      onTap: () {
                        Navigator.pushNamed(
                            context,
                            StringRouterUtil
                                .applicationFormSummaryScreenTabRoute,
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

  Widget actionDelete(int index) {
    int indexes =
        data.indexWhere((element) => element.id == dataFilter[index].id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Action',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            InkWell(
              onTap: () {
                docDeleteBloc.add(DocDeleteAttempt(DocumentDeleteRequestModel(
                    pHeader: dataFilter[count].docSource,
                    pId: dataFilter[index].id,
                    pFileName: dataFilter[index].filename,
                    pFilePaths: dataFilter[index].paths)));
              },
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: dataFilter[index].paths == ""
                          ? Colors.grey
                          : Colors.red,
                      size: 45,
                    ),
                  )),
            ),
            const SizedBox(width: 16),
            MultiBlocListener(
                listeners: [
                  BlocListener(
                      bloc: docUploadBloc,
                      listener: (_, DocUploadState state) async {
                        if (state is DocUploadLoading) {}
                        if (state is DocUploadLoaded) {
                          if (data[indexes].docSource == 'CLIENT_DOCUMENT') {
                            docUpdateBloc.add(DocUpdateAttempt(
                                DocumentUDateRequestModel(
                                    pApplicationNo: widget.applicationNo,
                                    pExpiredDate: data[indexes].expiredDate,
                                    pEffectiveDate: data[indexes].effectiveDate,
                                    pPromiseDate: '',
                                    pId: data[indexes].id,
                                    pSourceDoc: data[indexes].docSource)));
                          } else {
                            if (data[indexes].expiredDate != null) {
                              docUpdateBloc.add(DocUpdateAttempt(
                                  DocumentUDateRequestModel(
                                      pApplicationNo: widget.applicationNo,
                                      pExpiredDate: data[indexes].expiredDate,
                                      pEffectiveDate: '',
                                      pPromiseDate: '',
                                      pId: data[indexes].id,
                                      pSourceDoc: data[indexes].docSource)));
                            } else {
                              if (count == 0) {
                                setState(() {
                                  count = 1;
                                  data[indexes].isUpload = true;
                                });
                                Navigator.pop(context);
                                GeneralUtil().showSnackBarSuccess(
                                    context, 'Berhasil Upload');
                              }
                            }
                          }
                        }
                        if (state is DocUploadError) {
                          GeneralUtil().showSnackBar(context, state.error!);
                        }
                        if (state is DocUploadException) {}
                      }),
                  BlocListener(
                      bloc: docUpdateBloc,
                      listener: (_, DocUpdateState state) async {
                        if (state is DocUpdateLoading) {}
                        if (state is DocUpdateLoaded) {
                          if (data[indexes].docSource == 'CLIENT_DOCUMENT') {
                            setState(() {
                              data[indexes].isUpload = true;
                            });
                          }
                          if (count == 0) {
                            setState(() {
                              count = 1;
                            });
                            Navigator.pop(context);
                            GeneralUtil().showSnackBarSuccess(
                                context, 'Berhasil Upload');
                          }
                        }
                        if (state is DocUpdateError) {
                          GeneralUtil().showSnackBar(context, state.error!);
                        }
                        if (state is DocUpdateException) {}
                      })
                ],
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      count = 0;
                    });
                    if (data[indexes].docSource == 'CLIENT_DOCUMENT' &&
                        data[indexes].paths == '') {
                      EmptyDocWidget().showBottomEmpty(
                          context, 'Harap lengkapi data pendukung');
                    } else {
                      if (data[indexes].docSource == 'CLIENT_DOCUMENT' &&
                          data[indexes].effectiveDate == null &&
                          data[indexes].expiredDate == null) {
                        EmptyDocWidget().showBottomEmpty(context,
                            'Harap isi Effective Date dan Expired Date');
                      } else {
                        if (data[indexes].docSource == 'CLIENT_DOCUMENT') {
                          _uploadAttempt(context);
                          File imagefile = File(data[count].paths!);
                          Uint8List imagebytes = await imagefile.readAsBytes();
                          String base64string = base64.encode(imagebytes);
                          docUploadBloc.add(DocUploadAttempt(
                              DocumentUploadRequestModel(
                                  pBase64: base64string,
                                  pChild: data[indexes].headerCode,
                                  pFileName: data[indexes].filename,
                                  pFilePaths: data[indexes].id,
                                  pId: data[indexes].id,
                                  pHeader: data[indexes].docSource,
                                  pModule: "IFINLOS")));
                        } else {
                          if (data[indexes].isNew!) {
                            _uploadAttempt(context);
                            File imagefile = File(data[count].paths!);
                            Uint8List imagebytes =
                                await imagefile.readAsBytes();
                            String base64string = base64.encode(imagebytes);
                            docUploadBloc.add(DocUploadAttempt(
                                DocumentUploadRequestModel(
                                    pBase64: base64string,
                                    pChild: data[indexes].headerCode,
                                    pFileName: data[indexes].filename,
                                    pFilePaths: data[indexes].id,
                                    pId: data[indexes].id,
                                    pHeader: data[indexes].docSource,
                                    pModule: "IFINLOS")));
                          } else {
                            if (data[indexes].isRequired == '1' &&
                                data[indexes].promiseDate == null) {
                              EmptyDocWidget().showBottomEmpty(context,
                                  'Harap isi Promise Date jika tidak dapat memberikan Document yang dibutuhkan');
                            } else if (data[indexes].isRequired == '1') {
                              _uploadAttempt(context);
                              docUpdateBloc.add(DocUpdateAttempt(
                                  DocumentUDateRequestModel(
                                      pApplicationNo: widget.applicationNo,
                                      pExpiredDate: '',
                                      pEffectiveDate: '',
                                      pPromiseDate: data[indexes].promiseDate,
                                      pId: data[indexes].id,
                                      pSourceDoc: data[indexes].docSource)));
                            }
                          }
                        }
                      }
                    }
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                        child: Text('UPLOAD',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w600))),
                  ),
                ))
          ],
        )
      ],
    );
  }

  void _uploadAttempt(BuildContext context) {
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
