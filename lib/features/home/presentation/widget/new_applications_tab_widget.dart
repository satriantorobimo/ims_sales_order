import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_order/features/home/data/application_model.dart';
import 'package:sales_order/features/home/domain/repo/home_repo.dart';
import 'package:sales_order/features/home/presentation/bloc/app_list_bloc/bloc.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:shimmer/shimmer.dart';

class NewApplicationTabWidget extends StatefulWidget {
  const NewApplicationTabWidget({super.key});

  @override
  State<NewApplicationTabWidget> createState() =>
      _NewApplicationTabWidgetState();
}

class _NewApplicationTabWidgetState extends State<NewApplicationTabWidget> {
  AppListBloc appListBloc = AppListBloc(homeRepo: HomeRepo());

  @override
  void initState() {
    appListBloc.add(const AppListAttempt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Application',
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          BlocListener(
              bloc: appListBloc,
              listener: (_, AppListState state) {
                if (state is AppListLoading) {}
                if (state is AppListLoaded) {}
                if (state is AppListError) {}
                if (state is AppListException) {}
              },
              child: BlocBuilder(
                  bloc: appListBloc,
                  builder: (_, AppListState state) {
                    if (state is AppListLoading) {
                      return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.38,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: GridView.count(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 16,
                            childAspectRatio: 2 / 3.9,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8.0),
                            children: List.generate(6, (int index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.05)),
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, right: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                '',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w300,
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              Text(
                                                '',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        Colors.grey.shade300),
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
                    if (state is AppListLoaded) {
                      return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.38,
                        child: Center(
                          child: GridView.count(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 16,
                            childAspectRatio: 2 / 3.9,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8.0),
                            children: List.generate(
                                state.appListResponseModel.data!.length > 6
                                    ? 6
                                    : state.appListResponseModel.data!.length,
                                (int index) {
                              String date;
                              if (state.appListResponseModel.data![index]
                                      .applicationDate !=
                                  null) {
                                DateTime tempDate = DateFormat('yyyy-MM-dd')
                                    .parse(state.appListResponseModel
                                        .data![index].applicationDate!);
                                var inputDate =
                                    DateTime.parse(tempDate.toString());
                                var outputFormat = DateFormat('dd/MM/yyyy');
                                date = outputFormat.format(inputDate);
                              } else {
                                date = '';
                              }
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.05)),
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            width: 109,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: state
                                                            .appListResponseModel
                                                            .data![index]
                                                            .applicationStatus!
                                                            .toUpperCase() ==
                                                        'ON PROCESS'
                                                    ? thirdColor
                                                    : state
                                                                .appListResponseModel
                                                                .data![index]
                                                                .applicationStatus ==
                                                            'APPROVE'
                                                        ? primaryColor
                                                        : state
                                                                    .appListResponseModel
                                                                    .data![
                                                                        index]
                                                                    .applicationStatus ==
                                                                'CANCEL'
                                                            ? const Color(
                                                                0xFFFFEC3F)
                                                            : state
                                                                        .appListResponseModel
                                                                        .data![
                                                                            index]
                                                                        .applicationStatus ==
                                                                    'HOLD'
                                                                ? secondaryColor
                                                                : const Color(
                                                                    0xFFDF0000),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(18.0),
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                )),
                                            child: Center(
                                              child: Text(
                                                state
                                                    .appListResponseModel
                                                    .data![index]
                                                    .applicationStatus!,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w300,
                                                    color: state
                                                                    .appListResponseModel
                                                                    .data![
                                                                        index]
                                                                    .applicationStatus ==
                                                                'ON PROCESS' ||
                                                            state
                                                                    .appListResponseModel
                                                                    .data![
                                                                        index]
                                                                    .applicationStatus ==
                                                                'CENCEL' ||
                                                            state
                                                                    .appListResponseModel
                                                                    .data![
                                                                        index]
                                                                    .applicationStatus ==
                                                                'HOLD'
                                                        ? Colors.black
                                                        : Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, right: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state
                                                        .appListResponseModel
                                                        .data![index]
                                                        .purposeLoanName ??
                                                    '-',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                state.appListResponseModel
                                                    .data![index].clientCode!,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                'Rp. ${state.appListResponseModel.data![index].financingAmount}',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .date_range_rounded,
                                                        color:
                                                            Color(0xFF643FDB),
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        date,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Color(
                                                                0xFF643FDB)),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: secondaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
                                                    child: Center(
                                                      child: Text(
                                                        state
                                                                .appListResponseModel
                                                                .data![index]
                                                                .facilityDesc ??
                                                            '-',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.black),
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
                    return SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.38,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: GridView.count(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 16,
                          childAspectRatio: 2 / 3.9,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          children: List.generate(6, (int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.05)),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                  )),
                            );
                          }),
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
