import 'package:badges/badges.dart' as badges;
import 'package:emarket_buyer/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  static const String routeName = '/main-page';
  MainPage({Key? key, required this.initialIndex}) : super(key: key);

  final int initialIndex;

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  final List<Widget> pageList = [
    Homepage(),
    Cartpage(),
    const Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final List<BottomNavigationBarItem> bottomNavBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Obx(
          () => badges.Badge(
            badgeContent: Text(
              cartController.cartProducts.length.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            showBadge: cartController.cartProducts.isNotEmpty ? true : false,
            badgeAnimation: const badges.BadgeAnimation.rotation(
              animationDuration: Duration(seconds: 1),
              colorChangeAnimationDuration: Duration(seconds: 1),
              loopAnimation: false,
              curve: Curves.fastOutSlowIn,
              colorChangeAnimationCurve: Curves.easeInCubic,
            ),
            child: const Icon(Icons.shopping_cart),
          ),
        ),
        label: 'Cart',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
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
