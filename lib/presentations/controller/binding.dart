import 'package:get/get.dart';

import 'controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<FcmController>(FcmController(), permanent: true);
    Get.lazyPut(() => MapController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => SellerController(), fenix: true);
    Get.lazyPut(() => LocationController(), fenix: true);
    Get.lazyPut(() => CheckoutController(), fenix: true);
    Get.lazyPut(() => DirectionController(), fenix: true);
    Get.lazyPut(() => MainPageController(), fenix: true);
    Get.lazyPut(() => NetworkController(), fenix: true);
    Get.lazyPut(() => SellerController(), fenix: true);
    Get.lazyPut(() => LocationController(), fenix: true);
    Get.lazyPut(() => CheckoutController(), fenix: true);
    Get.lazyPut(() => DirectionController(), fenix: true);
    Get.lazyPut(() => QueryController(), fenix: true);
  }
}
