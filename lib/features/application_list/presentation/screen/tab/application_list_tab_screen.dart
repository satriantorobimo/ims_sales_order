import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_input_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/detail_info_widget.dart';
import 'package:sales_order/features/home/data/application_model.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/drop_down_util.dart';
import 'package:sales_order/utility/string_router_util.dart';

class ApplicationListTabScreen extends StatefulWidget {
  const ApplicationListTabScreen({super.key});

  @override
  State<ApplicationListTabScreen> createState() =>
      _ApplicationListTabScreenState();
}

class _ApplicationListTabScreenState extends State<ApplicationListTabScreen> {
  bool isLoading = true;
  List<ApplicationModel> menu = [];
  var selectedPageNumber = 0;
  var pagination = 5;
  var selectedClientType = 0;
  late List<CustDropdownMenuItem> clientType = [];

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
      clientType
          .add(const CustDropdownMenuItem(value: 0, child: Text("PERSONAL")));
      clientType
          .add(const CustDropdownMenuItem(value: 1, child: Text("CORPORATE")));
    });
  }

  Future<void> _showAlertDialogDetail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: Row(
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        DetailInfoWidget(
                            title: 'Application No',
                            content: '0000.LAP.2307.0000008.BCA MULTIFINANCE',
                            type: false),
                        DetailInfoWidget(
                            title: 'Branch',
                            content: 'HEAD OFFICE',
                            type: false),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        DetailInfoWidget(
                            title: 'Application Date',
                            content: '11/11/2022',
                            type: false),
                        DetailInfoWidget(
                            title: 'Facility Name',
                            content: 'VEHICLE',
                            type: true),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        DetailInfoWidget(
                            title: 'Purpose',
                            content: 'MULTI GUNA FASILITAS DANA',
                            type: false),
                        DetailInfoWidget(
                            title: 'Agreement No', content: '0', type: false),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const DetailInfoWidget(
                        title: 'Status', content: 'HOLD ENTRY', type: false),
                  ],
                ),
              )),
          actionsPadding: const EdgeInsets.only(bottom: 24.0),
          actions: <Widget>[
            Center(
              child: InkWell(
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
            )
          ],
        );
      },
    );
  }

  Future<void> _showAlertDialogClient() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Client Matching',
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
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24.0))),
            content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.55,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 290,
                            height: 90,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Client Type',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 290,
                                  height: 55,
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
                                  child: CustDropDown(
                                    items: clientType,
                                    hintText: "Select Type",
                                    borderRadius: 5,
                                    defaultSelectedIndex: 0,
                                    onChanged: (val) {
                                      setStates(() {
                                        selectedClientType = val;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          selectedClientType == 0
                              ? const ClientInputWidget(
                                  title: 'Document Type', content: 'KTP')
                              : const ClientInputWidget(
                                  title: 'Document Type', content: 'NPWP'),
                        ],
                      ),
                      selectedClientType == 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    ClientInputWidget(
                                        title: 'Mother Maiden Name',
                                        content: ''),
                                    ClientInputWidget(
                                        title: 'KTP No', content: ''),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    ClientInputWidget(
                                        title: 'Full Name', content: ''),
                                    ClientInputWidget(
                                        title: 'Place of Birth', content: ''),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const ClientInputWidget(
                                    title: 'Date of Birth', content: ''),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    ClientInputWidget(
                                        title: 'Established Date', content: ''),
                                    ClientInputWidget(
                                        title: 'NPWP No', content: ''),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const ClientInputWidget(
                                    title: 'Full Name', content: ''),
                              ],
                            )
                    ],
                  ),
                )),
            actionsPadding: const EdgeInsets.only(bottom: 24.0),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, StringRouterUtil.clientListScreenTabRoute);
                    },
                    child: Container(
                      width: 200,
                      height: 45,
                      decoration: BoxDecoration(
                        color: thirdColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Text('VIEW',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                  const SizedBox(width: 16),
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
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Application List',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 32.0),
              child: InkWell(
                onTap: () {
                  _showAlertDialogClient();
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
        body: Padding(
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
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(0.5)),
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
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: isLoading
                        ? Container()
                        : GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 16,
                            childAspectRatio: 2 / 1,
                            padding: const EdgeInsets.all(8.0),
                            children: List.generate(menu.length, (int index) {
                              return GestureDetector(
                                onTap: () {
                                  _showAlertDialogDetail();
                                },
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
                                                color: menu[index].status ==
                                                        'On Process'
                                                    ? thirdColor
                                                    : menu[index].status ==
                                                            'Approve'
                                                        ? primaryColor
                                                        : menu[index].status ==
                                                                'Cancel'
                                                            ? const Color(
                                                                0xFFFFEC3F)
                                                            : menu[index]
                                                                        .status ==
                                                                    'Hold'
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
                                                menu[index].status,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w300,
                                                    color: menu[index].status ==
                                                                'On Process' ||
                                                            menu[index]
                                                                    .status ==
                                                                'Cancel' ||
                                                            menu[index]
                                                                    .status ==
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
                                                        menu[index].date,
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
                                                    width: 75,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: secondaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
                                                    child: Center(
                                                      child: Text(
                                                        menu[index].type,
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
                ),
                const SizedBox(height: 16),
                isLoading
                    ? Container()
                    : SizedBox(
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
