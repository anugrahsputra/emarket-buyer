import 'package:emarket_buyer/models/model.dart';
import 'package:get/get.dart';

class BuyerController extends GetxController {
  final Rx<BuyerModel> _buyer = const BuyerModel().obs;

  final loading = false.obs;

  BuyerModel get buyer => _buyer.value;

  set buyer(BuyerModel value) {
    _buyer.value = value;
  }

  void clear() {
    _buyer.value = const BuyerModel();
  }
}
