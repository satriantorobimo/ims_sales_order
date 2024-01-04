import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_form_7/data/document_preview_request_model.dart';
import 'package:sales_order/features/application_form_7/domain/repo/form_7_repo.dart';
import 'package:sales_order/features/application_form_7/presentation/screen/bloc/doc_preview_bloc/bloc.dart';

class DocPreviewImageScreen extends StatefulWidget {
  final DocumentPreviewRequestModel documentPreviewRequestModel;
  const DocPreviewImageScreen(this.documentPreviewRequestModel, {super.key});

  @override
  State<DocPreviewImageScreen> createState() => _DocPreviewImageScreenState();
}

class _DocPreviewImageScreenState extends State<DocPreviewImageScreen> {
  DocPreviewBloc docPreviewBloc = DocPreviewBloc(form7repo: Form7Repo());

  @override
  void initState() {
    docPreviewBloc.add(DocPreviewAttempt(widget.documentPreviewRequestModel));
    super.initState();
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
                      if (state is DocPreviewLoaded) {}
                      if (state is DocPreviewError) {}
                      if (state is DocPreviewException) {
                        if (state.error == 'expired') {
                          // _sessionExpired();
                        }
                      }
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
                            return mainContent(
                                state.documentPreviewModel.value!.data!);
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
