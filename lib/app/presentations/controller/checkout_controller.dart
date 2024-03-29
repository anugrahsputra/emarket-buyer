import 'dart:developer';

import 'package:emarket_buyer/app/models/model.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:emarket_buyer/app/services/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CheckoutController extends GetxController {
  final Database database = Database();
  final LocalDatabase localDatabase = LocalDatabase();
  final BuyerController buyerController = Get.find<BuyerController>();
  final CartController cartController = Get.find<CartController>();
  final BuyerModel buyer = const BuyerModel();
  final SellerModel seller = const SellerModel();
  RxBool sortByDate = false.obs;
  RxBool isLoading = false.obs;
  RxBool isCancelled = false.obs;
  RxBool isDelivered = false.obs;
  RxBool isProcessing = false.obs;
  RxBool isShipping = false.obs;
  RxBool showCompleted = false.obs;
  RxBool showIncompleted = false.obs;
  var uuid = const Uuid();
  DateTime date = DateTime.now();
  RxString formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now()).obs;

  final checkouts = RxList<CheckoutModel>([]);

  @override
  void onInit() {
    fetchCheckout();
    super.onInit();
  }

  setLoading(bool value) {
    isLoading.value = value;
    update();
  }

  Future<void> fetchCheckout() async {
    try {
      String id = Get.find<AuthController>().user!.uid;
      checkouts.bindStream(database.fetchCheckout(id));
      log(checkouts.length.toString());
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> pullToRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    fetchCheckout();
  }

  Future<void> newCheckout(CheckoutModel checkoutModel) async {
    String id = Get.find<AuthController>().user!.uid;

    Map<String, List<CartModel>> cartToSeller = {};
    for (CartModel cart in checkoutModel.cart) {
      String sellerId = cart.sellerId;
      if (!cartToSeller.containsKey(sellerId)) {
        cartToSeller[sellerId] = [];
      }
      cartToSeller[sellerId]!.add(cart);
    }
    for (String sellerId in cartToSeller.keys) {
      List<CartModel> sellerCart = cartToSeller[sellerId]!;

      int total =
          sellerCart.fold(0, (sum, cart) => sum + cart.price * cart.quantity);
      final newCheckout = CheckoutModel(
        id: uuid.v4(),
        buyerId: id,
        sellerId: sellerId,
        note: checkoutModel.note,
        displayName: checkoutModel.displayName,
        isProcessing: checkoutModel.isProcessing,
        isDelivered: isDelivered.value,
        isCancelled: isCancelled.value,
        isShipping: isShipping.value,
        date: checkoutModel.date,
        location: checkoutModel.location,
        address: checkoutModel.address,
        additionalAddress: checkoutModel.additionalAddress,
        timestamp: checkoutModel.timestamp,
        cart: cartToSeller[sellerId]!,
        total: total,
      );
      await database.newCheckout(newCheckout, id);
      log('newCheckout controller');
    }
    await localDatabase.deleteProduct();
    await cartController.getCartItems();
    update();
  }

  Future<void> updateStatus(CheckoutModel id, Map<String, dynamic> data) async {
    await database.updateCheckoutStatus(id, data);
    update();
  }
}
