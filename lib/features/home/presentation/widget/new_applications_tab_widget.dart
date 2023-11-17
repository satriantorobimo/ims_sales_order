import 'package:flutter/material.dart';
import 'package:sales_order/features/home/data/application_model.dart';
import 'package:sales_order/utility/color_util.dart';

class NewApplicationTabWidget extends StatefulWidget {
  const NewApplicationTabWidget({super.key});

  @override
  State<NewApplicationTabWidget> createState() =>
      _NewApplicationTabWidgetState();
}

class _NewApplicationTabWidgetState extends State<NewApplicationTabWidget> {
  bool isLoading = true;
  List<ApplicationModel> menu = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    getMenu().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> getMenu() async {
    setState(() {
      menu.add(ApplicationModel(
          status: 'On Process',
          name: 'Johnny Iskandar',
          id: 'PSN.2103.00005',
          amount: '50.000.000',
          date: '01/02/2021',
          type: 'VEHICLE'));
      menu.add(ApplicationModel(
          status: 'Approve',
          name: 'Johnny Iskandar',
          id: 'PSN.2103.00005',
          amount: '50.000.000',
          date: '01/02/2021',
          type: 'VEHICLE'));
      menu.add(ApplicationModel(
          status: 'Cancel',
          name: 'Johnny Iskandar',
          id: 'PSN.2103.00005',
          amount: '50.000.000',
          date: '01/02/2021',
          type: 'VEHICLE'));
      menu.add(ApplicationModel(
          status: 'Hold',
          name: 'Johnny Iskandar',
          id: 'PSN.2103.00005',
          amount: '50.000.000',
          date: '01/02/2021',
          type: 'VEHICLE'));
      menu.add(ApplicationModel(
          status: 'Reject',
          name: 'Johnny Iskandar',
          id: 'PSN.2103.00005',
          amount: '50.000.000',
          date: '01/02/2021',
          type: 'VEHICLE'));
      menu.add(ApplicationModel(
          status: 'Reject',
          name: 'Johnny Iskandar',
          id: 'PSN.2103.00005',
          amount: '50.000.000',
          date: '01/02/2021',
          type: 'VEHICLE'));
    });
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
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.38,
            child: Center(
              child: isLoading
                  ? Container()
                  : GridView.count(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2 / 3.9,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      children: List.generate(menu.length, (int index) {
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
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      width: 109,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: menu[index].status ==
                                                  'On Process'
                                              ? thirdColor
                                              : menu[index].status == 'Approve'
                                                  ? primaryColor
                                                  : menu[index].status ==
                                                          'Cancel'
                                                      ? const Color(0xFFFFEC3F)
                                                      : menu[index].status ==
                                                              'Hold'
                                                          ? secondaryColor
                                                          : const Color(
                                                              0xFFDF0000),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(18.0),
                                            bottomLeft: Radius.circular(8.0),
                                          )),
                                      child: Center(
                                        child: Text(
                                          menu[index].status,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: menu[index].status ==
                                                          'On Process' ||
                                                      menu[index].status ==
                                                          'Cancel' ||
                                                      menu[index].status ==
                                                          'Hold'
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
                                          menu[index].name,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          menu[index].id,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          'Rp. ${menu[index].amount}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.date_range_rounded,
                                                  color: Color(0xFF643FDB),
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  menu[index].date,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Color(0xFF643FDB)),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: 75,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Center(
                                                child: Text(
                                                  menu[index].type,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black),
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
          )
        ],
      ),
    );
  }
}
