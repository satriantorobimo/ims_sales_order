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
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:path/path.dart' as path;
import 'package:shimmer/shimmer.dart';

class ApplicationForm7MobileScreen extends StatefulWidget {
  const ApplicationForm7MobileScreen({super.key, required this.applicationNo});
  final String applicationNo;

  @override
  State<ApplicationForm7MobileScreen> createState() =>
      _ApplicationForm7MobileScreenState();
}

class _ApplicationForm7MobileScreenState
    extends State<ApplicationForm7MobileScreen> with TickerProviderStateMixin {
  AnimationController? animationController;
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        context: _scaffoldKey.currentContext!,
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
                        pickImage(index, id).then((value) {
                          if (value == 'big') {
                            GeneralUtil()
                                .showSnackBar(context, 'Size Maximal 5MB');
                          }
                          Navigator.pop(context);
                        });
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
                        pickFile(index, id).then((value) {
                          if (value == 'big') {
                            GeneralUtil()
                                .showSnackBar(context, 'Size Maximal 5MB');
                          }
                          Navigator.pop(context);
                        });
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

  Future<String> pickFile(int index, int id) async {
    var maxFileSizeInBytes = 5 * 1048576;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'doc', 'docx', 'xls', 'xlsx'],
    );

    if (result != null) {
      var fileSize = result.files.first.size;
      if (fileSize <= maxFileSizeInBytes) {
        String filePath = result.files.single.path!;
        String basename = path.basename(filePath);
        int indexes = data.indexWhere((element) => element.id == id);
        log(basename);
        setState(() {
          dataFilter[index].paths = filePath;
          dataFilter[index].filename = basename;
          dataFilter[index].isNew = true;
          data[indexes].filename = basename;
          data[indexes].paths = filePath;
          data[indexes].isNew = true;
        });
        log('${data[indexes].isNew}');
      } else {
        return 'big';
      }
      return 'yes';
    } else {
      return 'notselect';
    }
  }

  Future<String> pickImage(int index, int id) async {
    try {
      var maxFileSizeInBytes = 5 * 1048576;
      ImagePicker imagePicker = ImagePicker();
      XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (pickedImage == null) return 'notselect';

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
        return 'big';
      }

      return 'yes';
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
      return 'notselect';
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

  void showBottomDelete(context, int index) {
    int indexes =
        data.indexWhere((element) => element.id == dataFilter[index].id);

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding:
                        const EdgeInsets.only(top: 32.0, left: 24, right: 24),
                    child: Center(
                      child: Image.asset(
                        'assets/img/back.png',
                        width: 150,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 24.0, left: 24, right: 24, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Detele File',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Apakah anda yakin ingin menghapus File ini?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 45,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child: Text('TIDAK',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ),
                    const SizedBox(width: 16),
                    isLoading
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 45,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                count = indexes;
                              });
                              if (data[indexes].isNew!) {
                                setState(() {
                                  data[indexes].paths = '';
                                  data[indexes].filename = '';
                                  data[indexes].isNew = false;
                                });
                                Navigator.pop(context);
                              } else {
                                docDeleteBloc.add(DocDeleteAttempt(
                                    DocumentDeleteRequestModel(
                                        pHeader: dataFilter[index].docSource,
                                        pId: dataFilter[index].id,
                                        pFileName: dataFilter[index].filename,
                                        pFilePaths: dataFilter[index].paths)));
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 45,
                              decoration: BoxDecoration(
                                color: thirdColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                  child: Text('YA',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600))),
                            ),
                          )
                  ],
                ),
                const SizedBox(height: 32),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
                bloc: docUpdateBloc,
                listener: (_, DocUpdateState state) async {
                  if (state is DocUpdateLoading) {}
                  if (state is DocUpdateLoaded) {
                    Navigator.pop(context);
                    GeneralUtil().showSnackBarSuccess(
                        context, 'Berhasil Update Document');
                  }
                  if (state is DocUpdateError) {
                    GeneralUtil().showSnackBar(context, state.error!);
                  }
                  if (state is DocUpdateException) {}
                }),
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
            BlocListener(
                bloc: docUploadBloc,
                listener: (_, DocUploadState state) async {
                  if (state is DocUploadLoading) {}
                  if (state is DocUploadLoaded) {
                    setState(() {
                      data[count].isUpload = true;
                      data[count].isNew = false;
                    });
                    if (data[count].docSource == 'CLIENT_DOCUMENT') {
                      docUpdateBloc.add(DocUpdateAttempt(
                          DocumentUDateRequestModel(
                              pApplicationNo: widget.applicationNo,
                              pExpiredDate: data[count].expiredDate,
                              pEffectiveDate: data[count].effectiveDate,
                              pPromiseDate: '',
                              pId: data[count].id,
                              pSourceDoc: data[count].docSource)));
                    } else {
                      if (data[count].expiredDate != null) {
                        docUpdateBloc.add(DocUpdateAttempt(
                            DocumentUDateRequestModel(
                                pApplicationNo: widget.applicationNo,
                                pExpiredDate: data[count].expiredDate,
                                pEffectiveDate: '',
                                pPromiseDate: '',
                                pId: data[count].id,
                                pSourceDoc: data[count].docSource)));
                      } else {
                        Navigator.pop(context);
                        GeneralUtil().showSnackBarSuccess(
                            context, 'Berhasil Upload Data');
                      }
                    }
                  }
                  if (state is DocUploadError) {
                    GeneralUtil().showSnackBar(context, state.error!);
                  }
                  if (state is DocUploadException) {}
                }),
            BlocListener(
              bloc: docDeleteBloc,
              listener: (_, DocDeleteState state) {
                if (state is DocDeleteLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (state is DocDeleteLoaded) {
                  setState(() {
                    data[count].expiredDate = null;
                    data[count].effectiveDate = null;
                    data[count].promiseDate = null;
                    data[count].paths = '';
                    data[count].filename = '';
                    data[count].isNew = false;
                    data[count].isUpload = false;
                  });
                  Navigator.pop(context);
                }
                if (state is DocDeleteError) {
                  setState(() {
                    isLoading = false;
                  });
                  GeneralUtil().showSnackBar(context, state.error!);
                }
                if (state is DocDeleteException) {
                  setState(() {
                    isLoading = false;
                  });
                  GeneralUtil()
                      .showSnackBar(context, 'Terjadi Kesalahan Sistem Delete');
                }
              },
            )
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
                        color: Colors.grey.withOpacity(0.05),
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
                                        .applicationFormSummaryScreenMobileRoute,
                                    arguments: widget.applicationNo,
                                  );
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
                                        ? '${index + 1}. Document Client'
                                        : dataFilter[index].docSource ==
                                                'APPLICATION_ASSET_DOCUMENT'
                                            ? '${index + 1}. Document Asset Application'
                                            : '${index + 1}. Document Application',
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
                                    ? () {
                                        _showBottomAttachment(
                                            index, dataFilter[index].id);
                                      }
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
                                    color: primaryColor,
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
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                                left: 16.0, right: 16.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                effDate,
                                                style: const TextStyle(
                                                    color: Color(0xFF333333),
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
                                                left: 16.0, right: 16.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                promDate,
                                                style: const TextStyle(
                                                    color: Color(0xFF333333),
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
                                onTap: () {
                                  _expDatePicker(index);
                                },
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
                                'Action',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              actionMethod(index, context),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
        ));
  }

  Widget actionMethod(int index, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () async {
            int indexes = data
                .indexWhere((element) => element.id == dataFilter[index].id);
            setState(() {
              count = indexes;
            });
            if (data[indexes].paths != '' &&
                data[indexes].docSource == 'CLIENT_DOCUMENT' &&
                data[indexes].effectiveDate != null &&
                data[indexes].expiredDate != null) {
              _uploadAttempt(context);
              File imagefile = File(data[indexes].paths!);
              Uint8List imagebytes = await imagefile.readAsBytes();
              String base64string = base64.encode(imagebytes);
              docUploadBloc.add(DocUploadAttempt(DocumentUploadRequestModel(
                  pBase64: base64string,
                  pChild: data[indexes].headerCode,
                  pFileName: data[indexes].filename,
                  pFilePaths: data[indexes].id,
                  pId: data[indexes].id,
                  pHeader: data[indexes].docSource,
                  pModule: "IFINLOS")));
            } else {
              if (data[indexes].paths != "" &&
                  data[indexes].docSource != 'CLIENT_DOCUMENT') {
                _uploadAttempt(context);
                File imagefile = File(data[indexes].paths!);
                Uint8List imagebytes = await imagefile.readAsBytes();
                String base64string = base64.encode(imagebytes);
                docUploadBloc.add(DocUploadAttempt(DocumentUploadRequestModel(
                    pBase64: base64string,
                    pChild: data[indexes].headerCode,
                    pFileName: data[indexes].filename,
                    pFilePaths: data[indexes].id,
                    pId: data[indexes].id,
                    pHeader: data[indexes].docSource,
                    pModule: "IFINLOS")));
              } else if (data[indexes].promiseDate != null &&
                  data[indexes].paths == "" &&
                  data[indexes].docSource != 'CLIENT_DOCUMENT') {
                _uploadAttempt(context);
                docUpdateBloc.add(DocUpdateAttempt(DocumentUDateRequestModel(
                    pApplicationNo: widget.applicationNo,
                    pExpiredDate: '',
                    pEffectiveDate: '',
                    pPromiseDate: data[indexes].promiseDate,
                    pId: data[indexes].id,
                    pSourceDoc: data[indexes].docSource)));
              } else {
                log('lalalalala');
              }
            }
          },
          child: func(index),
        ),
        InkWell(
          onTap: dataFilter[index].paths == ""
              ? null
              : () {
                  showBottomDelete(context, index);
                },
          child: Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.42,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: dataFilter[index].paths == ""
                  ? const Color(0xFFE1E1E1)
                  : Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
                child: Text('DELETE',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600))),
          ),
        ),
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

  Widget func(int index) {
    int indexes =
        data.indexWhere((element) => element.id == dataFilter[index].id);
    if (data[indexes].isUpload!) {
      return Container(
        height: 35,
        width: MediaQuery.of(context).size.width * 0.42,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE1E1E1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
            child: Text('UPLOAD',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600))),
      );
    } else {
      if (!data[indexes].isNew!) {
        if (data[indexes].promiseDate != null &&
            data[indexes].paths == "" &&
            data[indexes].docSource != 'CLIENT_DOCUMENT') {
          return Container(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.42,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                  child: Text('UPDATE DOC',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600))));
        } else {
          return Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.42,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE1E1E1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
                child: Text('UPLOAD',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600))),
          );
        }
      } else {
        if (data[indexes].paths != '' &&
            data[indexes].docSource == 'CLIENT_DOCUMENT' &&
            data[indexes].effectiveDate != null &&
            data[indexes].expiredDate != null) {
          return Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.42,
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
          );
        } else if (data[indexes].paths != "" &&
            data[indexes].docSource != 'CLIENT_DOCUMENT') {
          return Container(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.42,
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
                          fontWeight: FontWeight.w600))));
        } else {
          return Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.42,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE1E1E1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
                child: Text('UPLOAD',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600))),
          );
        }
      }
    }
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
