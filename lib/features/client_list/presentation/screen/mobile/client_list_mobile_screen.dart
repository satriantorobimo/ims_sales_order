import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/application_list/presentation/widget/detail_info_mobile_widget.dart';
import 'package:sales_order/features/client_list/data/client_matching_mode.dart';
import 'package:sales_order/features/client_list/domain/repo/client_matching_repo.dart';
import 'package:sales_order/features/client_list/presentation/bloc/client_match_bloc/bloc.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sales_order/features/client_list/data/client_matching_personal_response_model.dart'
    as resp;

class ClientListMobileScreen extends StatefulWidget {
  const ClientListMobileScreen({super.key, required this.clientMathcingModel});
  final ClientMathcingModel clientMathcingModel;

  @override
  State<ClientListMobileScreen> createState() => _ClientListMobileScreenState();
}

class _ClientListMobileScreenState extends State<ClientListMobileScreen> {
  bool isLoading = true;
  late List<resp.Data> data = [];
  late List<resp.Data> dataFilter = [];
  late List<resp.Data> dataFilterSearch = [];
  var selectedPageNumber = 0;
  var pagination = 5;
  ClientMatchBloc clientMatchBloc =
      ClientMatchBloc(clientMatchingRepo: ClientMatchingRepo());
  bool isEmpty = false;

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

  Future<void> _showBottomDetail() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 3),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Detail',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const DetailInfoMobileWidget(
                      title: 'Client No',
                      content: 'PSN.2103.00005',
                      type: false),
                  const DetailInfoMobileWidget(
                      title: 'Branch', content: 'HEAD OFFICE', type: false),
                  const DetailInfoMobileWidget(
                      title: 'Full Name',
                      content: 'WAWAN SETIAWAN',
                      type: false),
                  const DetailInfoMobileWidget(
                      title: 'ID No',
                      content: '763284639753659334',
                      type: false),
                  const DetailInfoMobileWidget(
                      title: 'Mother Maiden Name',
                      content: 'SENIPAH',
                      type: false),
                  const DetailInfoMobileWidget(
                      title: 'Date of Birth',
                      content: '11/11/2022',
                      type: false),
                  const DetailInfoMobileWidget(
                      title: 'Watchlist Status', content: 'CLEAR', type: true),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context,
                              StringRouterUtil
                                  .applicationForm1ScreenMobileRoute);
                        },
                        child: Container(
                          width: 155,
                          height: 35,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                              child: Text('USE',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600))),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 155,
                          height: 35,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                              child: Text('RESET',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600))),
                        ),
                      )
                    ],
                  )
                ],
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
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text(
            'Client List',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context,
                      StringRouterUtil.applicationForm1ScreenMobileRoute);
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
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/empty.png',
                      width: MediaQuery.of(context).size.width * 0.28,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No data found',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Try adjusting you search to find what you`re looking for.',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0),
                    child: Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'search record',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5),
                                  fontSize: 15),
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
                  BlocListener(
                      bloc: clientMatchBloc,
                      listener: (_, ClientMatchState state) {
                        if (state is ClientMatchLoading) {}
                        if (state is ClientMatchPersonalLoaded) {
                          if (state.clientMathcingPersonalResponseModel.data!
                              .isEmpty) {
                            setState(() {
                              isEmpty = true;
                            });
                          } else {
                            setState(() {
                              isEmpty = false;
                            });
                          }
                          setState(() {
                            dataFilter =
                                state.clientMathcingPersonalResponseModel.data!;
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
                              return Expanded(
                                child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: 10,
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const SizedBox(height: 8);
                                        },
                                        padding: const EdgeInsets.all(16),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            height: 110,
                                            width: double.infinity,
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
                                                  offset: const Offset(
                                                      -6, 4), // Shadow position
                                                ),
                                              ],
                                            ),
                                          );
                                        })),
                              );
                            }
                            if (state is ClientMatchPersonalLoaded) {
                              return Expanded(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: dataFilter.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(height: 8);
                                    },
                                    padding: const EdgeInsets.all(16),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          _showBottomDetail();
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
                                                  offset: const Offset(
                                                      -6, 4), // Shadow position
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Container(
                                                    width: 109,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: dataFilter[index]
                                                                    .checkStatus ==
                                                                'CLEAR'
                                                            ? const Color(
                                                                0xFFDA9BDA)
                                                            : dataFilter[index]
                                                                        .checkStatus ==
                                                                    'RELEASE'
                                                                ? const Color(
                                                                    0xFF70B96E)
                                                                : const Color(
                                                                    0xFFFF6C6C),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                                  18.0),
                                                          bottomLeft:
                                                              Radius.circular(
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
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
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
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      Text(
                                                        dataFilter[index]
                                                                .clientCode ??
                                                            '-',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.black),
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
                                                                fontSize: 12,
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
                                                                color: dataFilter[index]
                                                                            .checkStatus ==
                                                                        'CLEAR'
                                                                    ? primaryColor
                                                                    : const Color(
                                                                        0xFFC6C6C6),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6)),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: const Center(
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
                              );
                            }
                            return Expanded(
                              child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: 10,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(height: 8);
                                      },
                                      padding: const EdgeInsets.all(16),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          height: 110,
                                          width: double.infinity,
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
                                                offset: const Offset(
                                                    -6, 4), // Shadow position
                                              ),
                                            ],
                                          ),
                                        );
                                      })),
                            );
                          })),
                ],
              ));
  }
}
