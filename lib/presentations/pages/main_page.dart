import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  static const String routeName = '/main-page';
  MainPage({Key? key, required this.initialIndex}) : super(key: key);

  final int initialIndex;

  final BottomNavbarController controller = Get.put(BottomNavbarController());
  final CheckoutController checkoutController = Get.put(CheckoutController());

  final List<Widget> pageList = [
    Homepage(),
    OrderHistoryPage(),
    Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<NavigationDestination> navBarDestination = [
      const NavigationDestination(
        icon: Icon(Icons.home),
        label: 'Beranda',
      ),
      const NavigationDestination(
        icon: Icon(Icons.receipt_long),
        label: 'Riwayat',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person),
        label: 'Profil',
      ),
    ];
    return GetBuilder<BottomNavbarController>(
      builder: (_) {
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
