import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sales_order/features/application_list/presentation/screen/tab/application_list_tab_screen.dart';
import 'package:sales_order/features/home/presentation/screen/tab/home_tab_screen.dart';
import 'package:sales_order/features/simulation/presentation/screen/tab/simulation_tab_screen.dart';
import 'package:sales_order/features/tab/provider/tab_provider.dart';
import 'package:sales_order/utility/color_util.dart';

class TabTabScreen extends StatefulWidget {
  const TabTabScreen({super.key});

  @override
  State<TabTabScreen> createState() => _TabTabScreenState();
}

class _TabTabScreenState extends State<TabTabScreen> {
  final PageController _controller = PageController();
  List<Widget> listWidget = [
    const HomeTabScreen(),
    const ApplicationListTabScreen(),
    const SimulationTabScreen()
  ];

  void onTap(int index) {
    var bottomBarProvider = Provider.of<TabProvider>(context, listen: false);
    if (bottomBarProvider.page != index) {
      _controller.jumpToPage(index);
      setState(() {
        bottomBarProvider.setPage(index);
        bottomBarProvider.setTab(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarProvider = Provider.of<TabProvider>(context);
    return Scaffold(
      body: PageView(
          controller: _controller, onPageChanged: onTap, children: listWidget),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomBarProvider.page,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: onTap,
        iconSize: 18,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        selectedLabelStyle: const TextStyle(
            fontSize: 13,
            color: primaryColor,
            height: 1.5,
            fontWeight: FontWeight.w600),
        elevation: 0,
        selectedIconTheme: const IconThemeData(color: primaryColor),
        selectedItemColor: primaryColor,
        unselectedItemColor: const Color(0xFF575551),
        unselectedLabelStyle: const TextStyle(
            color: Color(0xFF575551), height: 1.5, fontWeight: FontWeight.w600),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icon/home.svg',
              color: const Color(0xFF484C52),
              height: 24,
              width: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icon/home.svg',
              color: primaryColor,
              height: 24,
              width: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icon/application.svg',
              color: const Color(0xFF484C52),
              height: 24,
              width: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icon/application.svg',
              color: primaryColor,
              height: 24,
              width: 24,
            ),
            label: 'Application List',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icon/calc.svg',
              color: const Color(0xFF484C52),
              height: 24,
              width: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icon/calc.svg',
              color: primaryColor,
              height: 24,
              width: 24,
            ),
            label: 'Simulation',
          ),
        ],
      ),
    );
  }
}
