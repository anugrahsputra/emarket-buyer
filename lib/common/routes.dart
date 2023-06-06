import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:get/get.dart';

class Routes {
  static final routes = [
    GetPage(
      name: '/main-page',
      page: () => const MainPage(
        initialIndex: 0,
      ),
    ),
    GetPage(
      name: '/home',
      page: () => Homepage(),
    ),
    GetPage(
      name: '/search-page',
      page: () => SearchPage(),
    ),
    GetPage(
      name: '/cart-page',
      page: () => Cartpage(),
    ),
    GetPage(
      name: '/profile-page',
      page: () => Profilepage(),
    ),
    GetPage(
      name: '/order-history-page',
      page: () => OrderHistoryPage(),
    ),
    GetPage(
      name: '/checkout-page',
      page: () => ChekcoutPage(),
    ),
    GetPage(
      name: '/location-page',
      page: () => const ChangeLocationPage(),
    ),
    GetPage(
      name: '/order-success-page',
      page: () => OrderSuccessPage(),
    ),
    GetPage(
      name: '/edit-profile-page',
      page: () => EditProfilePage(
        buyer: Get.arguments,
      ),
    ),
    GetPage(
      name: '/edit-account-page',
      page: () => EditAccountPage(),
    ),
    GetPage(
      name: '/seller-page',
      page: () => SellerPage(
        seller: Get.arguments,
      ),
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
