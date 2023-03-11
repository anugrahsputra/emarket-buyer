import 'package:emarket_buyer/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  static const String routeName = '/main-page';
  MainPage({Key? key}) : super(key: key);

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  List<Widget> pageList = [
    Homepage(),
    Cartpage(),
    const Profilepage(),
  ];

  List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      label: 'Cart',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavbarController>(
      builder: (_) {
        return Scaffold(
          body: pageList[controller.tabIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavBarItems,
            currentIndex: controller.tabIndex.value,
            onTap: (index) {
              controller.changedTabIndex(index);
            },
          ),
        );
      },
    );
  }
}
