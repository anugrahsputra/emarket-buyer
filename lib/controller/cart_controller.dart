import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/services/local_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final LocalDatabase _localDatabase = LocalDatabase();
  final cartProducts = RxList<CartModel>([]);

  final total = RxInt(0);
  final itemPrice = RxInt(0);

  @override
  void onInit() {
    getCartProducts();
    super.onInit();
  }

  getCartProducts() async {
    cartProducts.assignAll(await _localDatabase.getAllProducts());
    getTotal();
    update();
  }

  addProduct(CartModel cartModel) async {
    bool isExist = false;
    for (var element in cartProducts) {
      if (element.productId == cartModel.productId) {
        isExist = true;
        increaseQuantity(cartProducts.indexOf(element));
      }
    }
    if (!isExist) {
      await _localDatabase.insertProduct(cartModel);
      await getCartProducts();
    }
  }

  increaseQuantity(int index) async {
    cartProducts[index].quantity++;
    await _localDatabase.update(cartProducts[index]);
    getTotal();
    update();
  }

  decreaseQuantity(int index) async {
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
      await getCartProducts();
      update();
    }
  }

  void removeProduct(String productId) async {
    await _localDatabase.removeProduct(productId);
    await getCartProducts();
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
}
