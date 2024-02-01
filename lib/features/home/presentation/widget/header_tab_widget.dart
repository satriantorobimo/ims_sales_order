import 'package:flutter/material.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/database_helper.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/string_router_util.dart';

class HeaderTabWidget extends StatefulWidget {
  const HeaderTabWidget({super.key});

  @override
  State<HeaderTabWidget> createState() => _HeaderTabWidgetState();
}

class _HeaderTabWidgetState extends State<HeaderTabWidget> {
  String name = '';
  String uid = '';
  String branchName = '';

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final data = await DatabaseHelper.getUserData();
    setState(() {
      name = data[0]['name'];
      branchName = data[0]['branch_name'];
      uid = data[0]['uid'];
    });
  }

  Future<void> _showBottomLogout() {
    bool isTablet;
    if (GeneralUtil().deviceType() == 'tablet') {
      isTablet = true;
    } else {
      isTablet = false;
    }
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
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
                        'Are you sure?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Anda akan keluar dari akun ini',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
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
                      InkWell(
                        onTap: () async {
                          SharedPrefUtil.deleteSharedPref('token');
                          await DatabaseHelper.deleteUser();
                          if (isTablet) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                StringRouterUtil.loginScreenTabRoute,
                                (route) => false);
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                StringRouterUtil.loginScreenMobileRoute,
                                (route) => false);
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.person_2_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '$uid - $branchName',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
        InkWell(
          onTap: _showBottomLogout,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.redAccent,
            ),
            padding: const EdgeInsets.all(6),
            child: const Text(
              'Logout',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }
}
