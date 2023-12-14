import 'package:flutter/material.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_input_mobile_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/client_input_widget.dart';
import 'package:sales_order/features/application_list/presentation/widget/detail_info_mobile_widget.dart';
import 'package:sales_order/features/home/data/application_model.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/drop_down_util.dart';
import 'package:sales_order/utility/string_router_util.dart';

class ApplicationListMobileScreen extends StatefulWidget {
  const ApplicationListMobileScreen({super.key});

  @override
  State<ApplicationListMobileScreen> createState() =>
      _ApplicationListMobileScreenState();
}

class _ApplicationListMobileScreenState
    extends State<ApplicationListMobileScreen> {
  bool isLoading = true;
  List<ApplicationModel> menu = [];

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

  Future<void> _showBottom() {
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
                        'Client Matching',
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
                  SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Client Type',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.1)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                          ),
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
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
                      ? const ClientInputMobileWidget(
                          title: 'Document Type', content: 'KTP')
                      : const ClientInputMobileWidget(
                          title: 'Document Type', content: 'NPWP'),
                  selectedClientType == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 4),
                            ClientInputMobileWidget(
                                title: 'Mother Maiden Name', content: ''),
                            SizedBox(height: 4),
                            ClientInputMobileWidget(
                                title: 'KTP No', content: ''),
                            SizedBox(height: 4),
                            ClientInputMobileWidget(
                                title: 'Full Name', content: ''),
                            SizedBox(height: 4),
                            ClientInputMobileWidget(
                                title: 'Place of Birth', content: ''),
                            SizedBox(height: 4),
                            ClientInputMobileWidget(
                                title: 'Date of Birth', content: ''),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 4),
                            ClientInputMobileWidget(
                                title: 'Established Date', content: ''),
                            SizedBox(height: 4),
                            ClientInputMobileWidget(
                                title: 'NPWP No', content: ''),
                            SizedBox(height: 4),
                            ClientInputMobileWidget(
                                title: 'Full Name', content: ''),
                          ],
                        ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context,
                              StringRouterUtil.clientListScreenMobileRoute);
                        },
                        child: Container(
                          width: 180,
                          height: 35,
                          decoration: BoxDecoration(
                            color: thirdColor,
                            borderRadius: BorderRadius.circular(8),
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
                          width: 180,
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
                      title: 'Application No',
                      content: '0000.LAP.2307.0000008.BCA MULTIFINANCE',
                      type: false),
                  const DetailInfoMobileWidget(
                      title: 'Branch', content: 'HEAD OFFICE', type: false),
                  const DetailInfoMobileWidget(
                      title: 'Application Date',
                      content: '11/11/2022',
                      type: false),
                  const DetailInfoMobileWidget(
                      title: 'Facility Name', content: 'VEHICLE', type: true),
                  const DetailInfoMobileWidget(
                      title: 'Purpose',
                      content: 'MULTI GUNA FASILITAS DANA',
                      type: false),
                  const DetailInfoMobileWidget(
                      title: 'Agreement No', content: '0', type: false),
                  const DetailInfoMobileWidget(
                      title: 'Status', content: 'HOLD ENTRY', type: false),
                  const SizedBox(height: 16),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 180,
                        height: 35,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(8),
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
        title: const Text(
          'Application List',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: _showBottom,
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 28,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Material(
              elevation: 6,
              shadowColor: Colors.grey.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(width: 1.0, color: Color(0xFFEAEAEA))),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'search record',
                      isDense: true,
                      hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.5), fontSize: 15),
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
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: menu.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 8);
                },
                padding: const EdgeInsets.all(16),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: _showBottomDetail,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.05)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(-6, 4), // Shadow position
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
                                      color: menu[index].status == 'On Process'
                                          ? thirdColor
                                          : menu[index].status == 'Approve'
                                              ? primaryColor
                                              : menu[index].status == 'Cancel'
                                                  ? const Color(0xFFFFEC3F)
                                                  : menu[index].status == 'Hold'
                                                      ? secondaryColor
                                                      : const Color(0xFFDF0000),
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
                                                  menu[index].status == 'Hold'
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                fontWeight: FontWeight.w300,
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
                                                fontWeight: FontWeight.w300,
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
          )
        ],
      ),
    );
  }
}
