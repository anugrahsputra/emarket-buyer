import 'package:get/get.dart';

import 'controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<BuyerController>(BuyerController());
    Get.lazyPut(() => SellerController(), fenix: true);
    Get.put<ProductController>(ProductController());
    Get.lazyPut(() => BottomNavbarController());
    Get.lazyPut(() => LocationController(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => CheckoutController(), fenix: true);
  }
}
