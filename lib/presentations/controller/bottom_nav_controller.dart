import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbarController extends GetxController {
  var tabIndex = 0.obs;
  void changedTabIndex(int index) {
    tabIndex = index.obs;
    debugPrint('tabIndex: $tabIndex');
    update();
  }
}
