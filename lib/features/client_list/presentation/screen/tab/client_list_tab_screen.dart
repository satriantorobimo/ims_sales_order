import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/application_form_2/data/add_client_request_model.dart';
import 'package:sales_order/features/client_list/data/client_list_model.dart';
import 'package:sales_order/features/client_list/data/client_matching_personal_response_model.dart';
import 'package:sales_order/features/client_list/domain/repo/client_matching_repo.dart';
import 'package:sales_order/features/client_list/presentation/bloc/client_match_bloc/bloc.dart';
import 'package:sales_order/features/client_list/presentation/widget/detail_info_widget.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/database_helper.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:sales_order/features/client_list/data/client_matching_mode.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sales_order/features/client_list/data/client_matching_personal_response_model.dart'
    as resp;

class ClientListTabScreen extends StatefulWidget {
  const ClientListTabScreen({super.key, required this.clientMathcingModel});
  final ClientMathcingModel clientMathcingModel;

  @override
  State<ClientListTabScreen> createState() => _ClientListTabScreenState();
}

class _ClientListTabScreenState extends State<ClientListTabScreen> {
  bool isEmpty = false;
  List<ClientListModel> menu = [];
  var selectedPageNumber = 0;
  var pagination = 0;
  final int _perPage = 12;
  ClientMatchBloc clientMatchBloc =
      ClientMatchBloc(clientMatchingRepo: ClientMatchingRepo());
  late List<resp.Data> data = [];
  late List<resp.Data> dataFilter = [];

  @override
  void initState() {
    if (widget.clientMathcingModel.pDocumentType == 'NPWP' &&
        widget.clientMathcingModel.pDocumentNo != "") {
      clientMatchBloc.add(ClientMatchCorpAttempt(widget.clientMathcingModel));
    } else if (widget.clientMathcingModel.pDocumentType == 'KTP' &&
        widget.clientMathcingModel.pDocumentNo != "") {
      clientMatchBloc
          .add(ClientMatchPersonalAttempt(widget.clientMathcingModel));
    } else {
      setState(() {
        isEmpty = true;
      });
    }
    super.initState();
  }

  Future<void> _showBottomDialog(Data clientMathcingPersonalResponseModel) {
    String date;
    if (clientMathcingPersonalResponseModel.dateOfBirth != null) {
      DateTime tempDate = DateFormat('dd/MM/yyyy')
          .parse(clientMathcingPersonalResponseModel.dateOfBirth!);
      var inputDate = DateTime.parse(tempDate.toString());
      var outputFormat = DateFormat('dd/MM/yyyy');
      date = outputFormat.format(inputDate);
    } else {
      date = '';
    }
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 24, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Detail',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 24,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 24.0, left: 24, right: 24, bottom: 16),
                child: Row(
                  children: [
                    DetailInfoWidget(
                        title: 'Client No',
                        content: clientMathcingPersonalResponseModel.clientNo!,
                        type: false),
                    const SizedBox(width: 16),
                    const DetailInfoWidget(
                        title: 'Branch', content: 'HEAD OFFICE', type: false),
                    const SizedBox(width: 16),
                    DetailInfoWidget(
                        title: 'Full Name',
                        content: clientMathcingPersonalResponseModel.fullName!,
                        type: false),
                    const SizedBox(width: 16),
                    DetailInfoWidget(
                        title: 'ID No',
                        content: clientMathcingPersonalResponseModel.idNo!,
                        type: false),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                child: Row(
                  children: [
                    DetailInfoWidget(
                        title: 'Mother Maiden Name',
                        content: clientMathcingPersonalResponseModel
                            .motherMaidenName!,
                        type: false),
                    const SizedBox(width: 16),
                    DetailInfoWidget(
                        title: 'Place of Birth',
                        content:
                            clientMathcingPersonalResponseModel.placeOfBirth!,
                        type: false),
                    const SizedBox(width: 16),
                    DetailInfoWidget(
                        title: 'Date of Birth', content: date, type: false),
                    const SizedBox(width: 16),
                    DetailInfoWidget(
                        title: 'Watchlist Status',
                        content: clientMathcingPersonalResponseModel
                            .checkStatus!
                            .toUpperCase(),
                        type: true),
                  ],
                ),
              ),
              Row(
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
                          child: Text('CLOSE',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () async {
                      final data = await DatabaseHelper.getUserData(1);
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context,
                          StringRouterUtil.applicationForm1UseScreenTabRoute,
                          arguments: AddClientRequestModel(
                              pMarketingCode: data[0]['uid'],
                              pMarketingName: data[0]['name'],
                              pBranchCode: data[0]['branch_code'],
                              pBranchName: data[0]['branch_name'],
                              pClientCode: clientMathcingPersonalResponseModel
                                  .clientCode,
                              pClientNo:
                                  clientMathcingPersonalResponseModel.clientNo,
                              pDocNo: clientMathcingPersonalResponseModel.idNo,
                              pDocType: 'KTP'));
                    },
                    child: Container(
                      width: 200,
                      height: 45,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Text('USE',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          );
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
            'Client List',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                      context, StringRouterUtil.applicationForm1ScreenTabRoute);
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            )
          ],
        ),
        body: isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(28.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        elevation: 6,
                        shadowColor: Colors.grey.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                width: 1.0, color: Color(0xFFEAEAEA))),
                        child: SizedBox(
                          width: 350,
                          height: 60,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: 'search record',
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
                      const SizedBox(height: 24),
                      BlocListener(
                          bloc: clientMatchBloc,
                          listener: (_, ClientMatchState state) {
                            if (state is ClientMatchLoading) {}
                            if (state is ClientMatchCorpLoaded) {}
                            if (state is ClientMatchPersonalLoaded) {
                              setState(() {
                                pagination = (state
                                            .clientMathcingPersonalResponseModel
                                            .data!
                                            .length /
                                        12)
                                    .ceil();
                                if (pagination == 1) {
                                  dataFilter = state
                                      .clientMathcingPersonalResponseModel
                                      .data!;
                                } else {
                                  dataFilter = state
                                      .clientMathcingPersonalResponseModel.data!
                                      .sublist(
                                          (selectedPageNumber * _perPage),
                                          ((selectedPageNumber * _perPage) +
                                              _perPage));
                                }

                                data.addAll(state
                                    .clientMathcingPersonalResponseModel.data!);
                              });
                            }
                            if (state is ClientMatchError) {}
                            if (state is ClientMatchException) {}
                          },
                          child: BlocBuilder(
                              bloc: clientMatchBloc,
                              builder: (_, ClientMatchState state) {
                                if (state is ClientMatchLoading) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.66,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: GridView.count(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 24,
                                        crossAxisSpacing: 16,
                                        childAspectRatio: 2 / 1,
                                        padding: const EdgeInsets.all(8.0),
                                        children:
                                            List.generate(12, (int index) {
                                          return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.05)),
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
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.grey
                                                                  .shade300),
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        Text(
                                                          '',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              color: Colors.grey
                                                                  .shade300),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                            ),
                                                            Container(
                                                              width: 80,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                              ),
                                                            ),
                                                          ],
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
                                if (state is ClientMatchCorpLoaded) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.66,
                                    child: Center(
                                      child: GridView.count(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 24,
                                        crossAxisSpacing: 16,
                                        childAspectRatio: 2 / 1,
                                        padding: const EdgeInsets.all(8.0),
                                        children: List.generate(
                                            state.clientMathcingCorpResponseModel
                                                        .data!.length >
                                                    12
                                                ? 12
                                                : state
                                                    .clientMathcingCorpResponseModel
                                                    .data!
                                                    .length, (int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              // _showAlertDialogDetail();
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.05)),
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
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        width: 109,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: state
                                                                            .clientMathcingCorpResponseModel
                                                                            .data![
                                                                                index]
                                                                            .checkStatus ==
                                                                        'CLEAR'
                                                                    ? const Color(
                                                                        0xFFDA9BDA)
                                                                    : state.clientMathcingCorpResponseModel.data![index].checkStatus ==
                                                                            'RELEASE'
                                                                        ? const Color(
                                                                            0xFF70B96E)
                                                                        : const Color(
                                                                            0xFFFF6C6C),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          18.0),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          8.0),
                                                                )),
                                                        child: Center(
                                                          child: Text(
                                                            state
                                                                .clientMathcingCorpResponseModel
                                                                .data![index]
                                                                .checkStatus!,
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            state
                                                                .clientMathcingCorpResponseModel
                                                                .data![index]
                                                                .fullName!,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          Text(
                                                            state
                                                                .clientMathcingCorpResponseModel
                                                                .data![index]
                                                                .clientCode!,
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                state
                                                                    .clientMathcingCorpResponseModel
                                                                    .data![
                                                                        index]
                                                                    .clientNo!,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              InkWell(
                                                                onTap: state
                                                                            .clientMathcingCorpResponseModel
                                                                            .data![index]
                                                                            .checkStatus ==
                                                                        'CLEAR'
                                                                    ? () async {
                                                                        final data =
                                                                            await DatabaseHelper.getUserData(1);
                                                                        // ignore: use_build_context_synchronously
                                                                        Navigator.pushNamed(
                                                                            context,
                                                                            StringRouterUtil
                                                                                .applicationForm1UseScreenTabRoute,
                                                                            arguments: AddClientRequestModel(
                                                                                pMarketingCode: data[0]['uid'],
                                                                                pMarketingName: data[0]['name'],
                                                                                pBranchCode: data[0]['branch_code'],
                                                                                pBranchName: data[0]['branch_name'],
                                                                                pClientCode: state.clientMathcingCorpResponseModel.data![index].clientCode,
                                                                                pClientNo: state.clientMathcingCorpResponseModel.data![index].clientNo,
                                                                                pDocNo: state.clientMathcingCorpResponseModel.data![index].idNo,
                                                                                pDocType: 'KTP'));
                                                                      }
                                                                    : null,
                                                                child:
                                                                    Container(
                                                                  width: 80,
                                                                  height: 30,
                                                                  decoration: BoxDecoration(
                                                                      color: state.clientMathcingCorpResponseModel.data![index].checkStatus ==
                                                                              'CLEAR'
                                                                          ? primaryColor
                                                                          : const Color(
                                                                              0xFFC6C6C6),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      'Use',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          );
                                        }),
                                      ),
                                    ),
                                  );
                                }
                                if (state is ClientMatchPersonalLoaded) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.66,
                                    child: Center(
                                      child: GridView.count(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 24,
                                        crossAxisSpacing: 16,
                                        childAspectRatio: 2 / 1,
                                        padding: const EdgeInsets.all(8.0),
                                        children: List.generate(
                                            dataFilter.length, (int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              _showBottomDialog(
                                                  dataFilter[index]);
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.05)),
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
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        width: 109,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: dataFilter[index]
                                                                            .checkStatus ==
                                                                        'CLEAR'
                                                                    ? const Color(
                                                                        0xFFDA9BDA)
                                                                    : dataFilter[index].checkStatus ==
                                                                            'RELEASE'
                                                                        ? const Color(
                                                                            0xFF70B96E)
                                                                        : const Color(
                                                                            0xFFFF6C6C),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          18.0),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          8.0),
                                                                )),
                                                        child: Center(
                                                          child: Text(
                                                            dataFilter[index]
                                                                    .checkStatus ??
                                                                '-',
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            dataFilter[index]
                                                                    .fullName ??
                                                                '-',
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          Text(
                                                            dataFilter[index]
                                                                    .clientCode ??
                                                                '-',
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                dataFilter[index]
                                                                        .clientNo ??
                                                                    '-',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Container(
                                                                width: 80,
                                                                height: 30,
                                                                decoration: BoxDecoration(
                                                                    color: dataFilter[index].checkStatus ==
                                                                            'CLEAR'
                                                                        ? primaryColor
                                                                        : const Color(
                                                                            0xFFC6C6C6),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6)),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    'Use',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          );
                                        }),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              })),
                      const SizedBox(height: 16),
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
                                        dataFilter = data.sublist(
                                            (selectedPageNumber * _perPage),
                                            ((selectedPageNumber * _perPage) +
                                                _perPage));
                                      });
                                    },
                                    child: const Icon(
                                        Icons.keyboard_arrow_left_rounded,
                                        size: 32)),
                            ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: pagination,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(width: 4);
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPageNumber = index;
                                        dataFilter = data.sublist(
                                            (selectedPageNumber * _perPage),
                                            ((selectedPageNumber * _perPage) +
                                                _perPage));
                                      });
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: selectedPageNumber == index
                                              ? primaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
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
                                        dataFilter = data.sublist(
                                            (selectedPageNumber * _perPage),
                                            ((selectedPageNumber * _perPage) +
                                                _perPage));
                                      });
                                    },
                                    child: const Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      size: 32,
                                    ),
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
