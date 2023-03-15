import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:get/get.dart';

class Routes {
  static final routes = [
    GetPage(
      name: '/main-page',
      page: () => MainPage(
        initialIndex: 0,
      ),
    ),
    GetPage(
      name: '/home',
      page: () => Homepage(),
    ),
    GetPage(
      name: '/order-page',
      page: () => Cartpage(),
    ),
    GetPage(
      name: '/profile-page',
      page: () => const Profilepage(),
    ),
    GetPage(
      name: '/checkout-page',
      page: () => ChekcoutPage(),
    ),
    GetPage(
      name: '/order-success-page',
      page: () => OrderSuccessPage(),
    ),
    GetPage(
      name: '/signin',
      page: () => SigninPage(),
    ),
    GetPage(
      name: '/signup',
      page: () => SignUpPage(),
    ),
  ];
}
