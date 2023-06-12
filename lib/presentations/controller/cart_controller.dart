import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:emarket_buyer/helper/helper.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/services/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final _localDatabase = LocalDatabase();
  final cartProducts = RxList<CartModel>([]);
  final localNotificationHelper = LocalNotificationHelper();
  final total = RxInt(0);
  final itemPrice = RxInt(0);
  RxBool isExist = false.obs;

  @override
  void onInit() {
    getCartItems();
    super.onInit();
  }

  Future<void> getCartItems() async {
    cartProducts.assignAll(await _localDatabase.getAllProducts());
    getTotal();
    cartNotif();
    update();
  }

  Future<bool> cartNotif() async {
    if (cartProducts.isNotEmpty) {
      debugPrint('Notification active');
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 8),
        1,
        BackgroundService.callback,
        exact: true,
        wakeup: true,
        startAt: DateTime.now(),
      );
    } else {
      debugPrint('Notification inactive');
      return await AndroidAlarmManager.cancel(1);
    }
  }

  Future<void> addProduct(CartModel cartModel) async {
    isExist.value = false;
    for (var element in cartProducts) {
      if (element.productId == cartModel.productId) {
        if (element.sellerId == cartModel.sellerId) {
          isExist.value = true;
          increaseQuantity(cartProducts.indexOf(element));
          Fluttertoast.showToast(msg: '${cartModel.name} berhasil ditambahkan');
        } else {
          bool replaceItem = await showBottomSheet(cartModel, Get.context!);
          if (replaceItem) {
            cartProducts.remove(element);
            await _localDatabase.deleteProduct();
          }
          return;
        }
      }
    }

    if (!isExist.value) {
      bool hasItemsFromOtherSeller = cartProducts.any((element) =>
          element.sellerId != cartModel.sellerId &&
          element.productId != cartModel.productId);

      if (hasItemsFromOtherSeller) {
        bool replaceItem = await showBottomSheet(cartModel, Get.context!);
        if (replaceItem) {
          var itemToRemove = cartProducts.firstWhere((element) =>
              element.sellerId != cartModel.sellerId &&
              element.productId != cartModel.productId);
          cartProducts.remove(itemToRemove);
          await _localDatabase.deleteProduct();
        } else {
          return;
        }
      }

      Fluttertoast.showToast(msg: '${cartModel.name} berhasil ditambahkan');
      await _localDatabase.insertProduct(cartModel);
      await getCartItems();
    }
  }

  Future<void> increaseQuantity(int index) async {
    cartProducts[index].quantity++;
    final productIndex = Get.find<ProductController>();
    final product = productIndex.product;
    if (cartProducts[index].quantity > product[index].quantity) {
      cartProducts[index].quantity--;
      Fluttertoast.showToast(
        msg:
            'hmm, sepertinya ${product[index].name} hanya tersisa ${product[index].quantity} lagi.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
      return;
    }
    await _localDatabase.update(cartProducts[index]);
    getTotal();
    update();
  }

  Future<void> decreaseQuantity(int index) async {
    if (cartProducts[index].quantity != 0) {
      cartProducts[index].quantity--;
      await _localDatabase.update(cartProducts[index]);
      getTotal();
      getItemPrice(index);
      update();
    }
    if (cartProducts[index].quantity == 0) {
      _localDatabase.removeProduct(cartProducts[index].productId);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
            '${cartProducts[index].name} berhasil dihapus',
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(50),
          duration: const Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
      getTotal();
      getItemPrice(index);
      await getCartItems();
      update();
    }
  }

  Future<void> removeProduct(String productId) async {
    await _localDatabase.removeProduct(productId);
    await getCartItems();
    update();
  }

  Future<void> clearCart() async {
    await _localDatabase.deleteProduct();
    await getCartItems();
    update();
  }

  getTotal() {
    total.value = cartProducts.fold<int>(
        0, (sum, element) => sum + element.price * element.quantity);
    update();
  }

  getItemPrice(int index) {
    itemPrice.value = cartProducts[index].price * cartProducts[index].quantity;
    update();
  }

  showBottomSheet(CartModel cart, BuildContext context) {
    return showModalBottomSheet(
        isDismissible: false,
        transitionAnimationController: AnimationController(
          vsync: Navigator.of(context),
          duration: const Duration(milliseconds: 500),
        ),
        context: context,
        builder: (context) {
          return Container(
            height: 500,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Mau pesan dari penjual ini?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Image.asset(
                    'assets/illustration/illustration_1.png',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Boleeeh, tapi kita harus mengganti item yang sudah ada di keranjang pembelian kamu terlebih dahulu.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey[300],
                      ),
                      onPressed: () {
                        Get.back(result: false);
                      },
                      child: const Text('Batalkan'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Get.back(result: true);
                        Fluttertoast.showToast(
                            msg: '${cart.name} berhasil ditambahkan');
                      },
                      child: const Text('Ganti'),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
