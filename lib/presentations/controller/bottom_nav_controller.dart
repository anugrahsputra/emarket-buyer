import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbarController extends GetxController {
  Widget currentPage = Homepage();
  var tabIndex = 0.obs;

  Widget get getCurrentPage => currentPage;

  void changePage(int index) {
    final queryClear = Get.find<QueryController>().clear();
    tabIndex.value = index;
    switch (index) {
      case 0:
        currentPage = Homepage();
        queryClear;
        update();
        break;
      case 1:
        currentPage = SearchPage();
        update();
        break;
      case 2:
        currentPage = OrderHistoryPage();
        queryClear;
        update();
        break;
      case 3:
        currentPage = Profilepage();
        queryClear;
        update();
        break;
      default:
        currentPage = Homepage();
        queryClear;
        update();
    }
  }
}
