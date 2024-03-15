import 'package:flutter/material.dart';

class TabProvider with ChangeNotifier {
  int _page = 0;
  int _tabNumber = 0;

  int get page => _page;
  int get tabNumber => _tabNumber;

  void setPage(int value) {
    _page = value;
    notifyListeners();
  }

  void setTab(int value) {
    _tabNumber = value;
    notifyListeners();
  }
}
