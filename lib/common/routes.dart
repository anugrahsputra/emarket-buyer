import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:get/get.dart';

class Routes {
  static final routes = [
    GetPage(
      name: '/main-page',
      page: () => MainPage(),
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
      name: '/signin',
      page: () => SigninPage(),
    ),
    GetPage(
      name: '/signup',
      page: () => SignUpPage(),
    ),
  ];
}
