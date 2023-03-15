import 'package:get/get.dart';

import 'controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<BuyerController>(BuyerController(), permanent: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => CheckoutController(), fenix: true);
  }
}
