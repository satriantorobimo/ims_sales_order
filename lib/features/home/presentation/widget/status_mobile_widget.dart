import 'package:flutter/material.dart';
import 'package:sales_order/features/home/data/menu_model.dart';
import 'package:sales_order/utility/color_util.dart';

class StatusMobileWidget extends StatefulWidget {
  const StatusMobileWidget({super.key});

  @override
  State<StatusMobileWidget> createState() => _StatusMobileWidgetState();
}

class _StatusMobileWidgetState extends State<StatusMobileWidget> {
  bool isLoading = true;
  List<MenuModel> menu = [];

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
      menu.add(MenuModel(
          color: secondaryColor,
          title: 'Hold',
          subTitle: 'Marketing',
          content: '721.000'));
      menu.add(MenuModel(
          color: secondaryColor,
          title: 'On Process',
          subTitle: 'CC',
          content: '1.156'));
      menu.add(MenuModel(
          color: thirdColor,
          title: 'On Process',
          subTitle: 'CA',
          content: '367.000'));
      menu.add(MenuModel(
          color: thirdColor,
          title: 'Cancel',
          subTitle: 'Marketing',
          content: '239.000'));
      menu.add(MenuModel(
          color: secondaryColor,
          title: 'Reject',
          subTitle: 'CC',
          content: '721.000'));
      menu.add(MenuModel(
          color: secondaryColor,
          title: 'Approve',
          subTitle: 'Final Check',
          content: '367.000'));
      menu.add(MenuModel(
          color: thirdColor,
          title: 'Cancel',
          subTitle: 'Marketing',
          content: '239.000'));
      menu.add(MenuModel(
          color: thirdColor,
          title: 'Approve',
          subTitle: 'CC',
          content: '721.000'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Application Status',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.57,
            child: Center(
              child: isLoading
                  ? Container()
                  : GridView.count(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2 / 1.0,
                      padding: const EdgeInsets.all(8.0),
                      children: List.generate(menu.length, (int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: menu[index].color!,
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${menu[index].title!} ${menu[index].subTitle!}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    menu[index].content!,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
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
