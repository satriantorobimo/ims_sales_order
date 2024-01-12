import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sales_order/features/application_list/presentation/screen/mobile/application_list_mobile_screen.dart';
import 'package:sales_order/features/history/presentation/screen/mobile/history_mobile_screen.dart';
import 'package:sales_order/features/home/presentation/screen/mobile/home_mobile_screen.dart';
import 'package:sales_order/features/profile/presentation/screen/mobile/profile_mobile_screen.dart';
import 'package:sales_order/features/announcement/presentation/screen/mobile/search_mobile_screen.dart';
import 'package:sales_order/features/tab/provider/tab_provider.dart';
import 'package:sales_order/utility/color_util.dart';

class TabMobileScreen extends StatefulWidget {
  const TabMobileScreen({super.key});

  @override
  State<TabMobileScreen> createState() => _TabMobileScreenState();
}

class _TabMobileScreenState extends State<TabMobileScreen> {
  Widget _getPage(int index) {
    if (index == 0) {
      return const HomeMobileScreen();
    }
    if (index == 1) {
      return const ApplicationListMobileScreen();
    }
    if (index == 2) {
      return const SearchMobileScreen();
    }
    if (index == 3) {
      return const HistoryMobileScreen();
    }
    if (index == 4) {
      return const ProfileMobileScreen();
    }

    return const HomeMobileScreen();
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarProvider = Provider.of<TabProvider>(context);
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomBarProvider.page,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: (index) {
            bottomBarProvider.setPage(index);
            bottomBarProvider.setTab(0);
          },
          iconSize: 18,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(
              fontSize: 12,
              color: primaryColor,
              height: 1.5,
              fontWeight: FontWeight.w400),
          elevation: 0,
          selectedIconTheme: const IconThemeData(color: primaryColor),
          selectedItemColor: primaryColor,
          unselectedItemColor: const Color(0xFF575551),
          unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF575551),
              height: 1.5,
              fontWeight: FontWeight.w400),
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
              label: 'Aplication List',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icon/search.svg',
                color: const Color(0xFF484C52),
                height: 24,
                width: 24,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icon/search.svg',
                color: primaryColor,
                height: 24,
                width: 24,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icon/history.svg',
                color: const Color(0xFF484C52),
                height: 24,
                width: 24,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icon/history.svg',
                color: primaryColor,
                height: 24,
                width: 24,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icon/profile.svg',
                color: const Color(0xFF484C52),
                height: 24,
                width: 24,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icon/profile.svg',
                color: primaryColor,
                height: 24,
                width: 24,
              ),
              label: 'Profile',
            ),
          ],
        ),
        body: _getPage(bottomBarProvider.page));
  }
}
