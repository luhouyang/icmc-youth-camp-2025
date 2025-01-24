import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:yc_icmc_2025/entities/group_entity.dart';

class AppState extends ChangeNotifier {
  // variables
  final AdaptiveThemeMode savedThemeMode;
  List<GroupEntity> groupList = [];

  bool isDarkMode = false;

  bool isNavBarCollapsed = false;
  int bottomNavIndex = 0;

  AppState({required this.savedThemeMode}) {
    if (savedThemeMode.isDark) {
      isDarkMode = true;
      notifyListeners();
    }
  }

  // setter
  void setDarkMode(bool val) {
    isDarkMode = val;
    notifyListeners();
  }

  void setNavBarCollapsed(bool val) {
    isNavBarCollapsed = val;
    notifyListeners();
  }

  void setBottomNavIndex(int idx) {
    bottomNavIndex = idx;
    notifyListeners();
  }

  void setGroupList(List<GroupEntity> gplst) {
    groupList = gplst;
  }

  // getter
}
