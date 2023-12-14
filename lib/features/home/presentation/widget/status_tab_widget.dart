import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/home/domain/repo/home_repo.dart';
import 'package:sales_order/features/home/presentation/bloc/app_status_bloc/bloc.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:shimmer/shimmer.dart';

class StatusTabWidget extends StatefulWidget {
  const StatusTabWidget({super.key});

  @override
  State<StatusTabWidget> createState() => _StatusTabWidgetState();
}

class _StatusTabWidgetState extends State<StatusTabWidget> {
  AppStatusBloc appStatusBloc = AppStatusBloc(homeRepo: HomeRepo());

  @override
  void initState() {
    appStatusBloc.add(const AppStatusAttempt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Application Status',
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          BlocListener(
              bloc: appStatusBloc,
              listener: (_, AppStatusState state) {
                if (state is AppStatusLoading) {}
                if (state is AppStatusLoaded) {}
                if (state is AppStatusError) {}
                if (state is AppStatusException) {}
              },
              child: BlocBuilder(
                  bloc: appStatusBloc,
                  builder: (_, AppStatusState state) {
                    if (state is AppStatusLoading) {
                      return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.33,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: GridView.count(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 32,
                            crossAxisSpacing: 16,
                            childAspectRatio: 2 / 3.20,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8.0),
                            children: List.generate(9, (int index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.grey.shade300,
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade300),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade300),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade300),
                                        ),
                                      ],
                                    )),
                              );
                            }),
                          ),
                        ),
                      );
                    }
                    if (state is AppStatusLoaded) {
                      return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Center(
                            child: GridView.count(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 32,
                          crossAxisSpacing: 16,
                          childAspectRatio: 2.50 / 3.50,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          children: List.generate(
                              state.appStatusResponseModel.data!.length,
                              (int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: GeneralUtil().isOdd(index) == true
                                        ? secondaryColor
                                        : thirdColor,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state
                                                .appStatusResponseModel
                                                .data![index]
                                                .applicationStatus!,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            state.appStatusResponseModel
                                                .data![index].levelStatus!,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        state.appStatusResponseModel
                                            .data![index].applicationCount
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ],
                                  )),
                            );
                          }),
                        )),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.33,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: GridView.count(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 32,
                          crossAxisSpacing: 16,
                          childAspectRatio: 2 / 3.20,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          children: List.generate(9, (int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.grey.shade300,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade300),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade300),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade300),
                                      ),
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
