import 'package:emarket_buyer/app/helper/helper.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:emarket_buyer/app/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/main-page';
  const MainPage({Key? key, required this.initialIndex}) : super(key: key);

  final int initialIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      localNotificationHelper
          .initNotifications(flutterLocalNotificationsPlugin);
      localNotificationHelper.configureSelectionNotificationSubject(
        context,
        Cartpage.routeName,
      );
    });
  }

  final CheckoutController checkoutController = Get.find<CheckoutController>();
  final NetworkController networkController = Get.find<NetworkController>();

  @override
  Widget build(BuildContext context) {
    final List<NavigationDestination> navBarDestination = [
      const NavigationDestination(
        icon: Icon(Icons.home),
        label: 'Beranda',
      ),
      const NavigationDestination(
        icon: Icon(Icons.search_rounded),
        label: 'Cari',
      ),
      const NavigationDestination(
        icon: Icon(Icons.receipt_long),
        label: 'Pesanan',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person),
        label: 'Profil',
      ),
    ];
    return GetBuilder<MainPageController>(
      builder: (controller) {
        return Scaffold(
          body: controller.currentPage,
          bottomNavigationBar: NavigationBar(
            destinations: navBarDestination,
            onDestinationSelected: (index) {
              controller.changePage(index);
            },
            selectedIndex: controller.tabIndex.value,
          ),
        );
      },
    );
  }
}
