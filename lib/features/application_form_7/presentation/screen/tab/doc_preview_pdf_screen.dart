import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sales_order/features/application_form_7/data/document_preview_request_model.dart';
import 'package:sales_order/features/application_form_7/domain/repo/form_7_repo.dart';
import '../bloc/doc_preview_bloc/bloc.dart';

class DocPreviewPdfScreen extends StatefulWidget {
  final DocumentPreviewRequestModel documentPreviewRequestModel;
  const DocPreviewPdfScreen(this.documentPreviewRequestModel, {super.key});

  @override
  State<DocPreviewPdfScreen> createState() => _DocPreviewPdfScreenState();
}

class _DocPreviewPdfScreenState extends State<DocPreviewPdfScreen> {
  DocPreviewBloc docPreviewBloc = DocPreviewBloc(form7repo: Form7Repo());

  @override
  void initState() {
    docPreviewBloc.add(DocPreviewAttempt(widget.documentPreviewRequestModel));
    super.initState();
  }

  createPdf(String base64pdf, String fileName) async {
    var bytes = base64Decode(base64pdf.replaceAll('\n', ''));
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$fileName");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    await OpenFile.open("${output.path}/$fileName");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocListener(
                    bloc: docPreviewBloc,
                    listener: (_, DocPreviewState state) {
                      if (state is DocPreviewLoaded) {
                        createPdf(state.documentPreviewModel.value!.data!,
                            state.documentPreviewModel.value!.filename!);
                      }
                      if (state is DocPreviewError) {}
                    },
                    child: BlocBuilder(
                        bloc: docPreviewBloc,
                        builder: (_, DocPreviewState state) {
                          if (state is DocPreviewLoading) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 60.0),
                              child: Center(
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          }
                          if (state is DocPreviewLoaded) {
                            return Container();
                          }
                          if (state is DocPreviewError) {
                            return Container();
                          }
                          return Container();
                        })),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Center(
                      child: Text(
                        'BACK',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainContent(String value) {
    return Center(
      child: Image.memory(
        base64Decode(value),
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
