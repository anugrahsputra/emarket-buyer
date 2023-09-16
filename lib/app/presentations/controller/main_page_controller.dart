// ignore_for_file: unrelated_type_equality_checks

import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:emarket_buyer/app/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MainPageController extends GetxController {
  final NetworkController networkController = Get.find<NetworkController>();
  Widget currentPage = const Homepage();
  var tabIndex = 0.obs;

  Widget get getCurrentPage => currentPage;

  void changePage(int index) {
    final queryClear = Get.find<QueryController>().clear();
    if (networkController.connectionStatus == 0) {
      Fluttertoast.showToast(msg: 'Tidak koneksi internet');
    }
    tabIndex.value = index;
    switch (index) {
      case 0:
        currentPage = const Homepage();
        queryClear;
        update();
        break;
      case 1:
        currentPage = SearchPage();
        update();
        break;
      case 2:
        currentPage = const OrderHistoryPage();
        queryClear;
        update();
        break;
      case 3:
        currentPage = Profilepage();
        queryClear;
        update();
        break;
      default:
        currentPage = const Homepage();
        queryClear;
        update();
    }
  }
}
