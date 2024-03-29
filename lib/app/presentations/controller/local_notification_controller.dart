import 'dart:async';

import 'package:emarket_buyer/app/helper/local_notification_helper.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';

class LocalNotificationController extends GetxController {
  Timer? timer;
  LocalNotificationHelper localNotificationHelper = LocalNotificationHelper();

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  startTimer() async {
    timer = Timer.periodic(const Duration(hours: 6), (Timer t) {
      checkCart();
    });
  }

  checkCart() async {
    final cart = Get.find<CartController>();
    final cartList = cart.cartProducts;
    if (cartList.isNotEmpty) {
      await localNotificationHelper
          .showNotifications(flutterLocalNotificationsPlugin);
    }
    debugPrint('Notification coming');

    startTimer();
  }
}
