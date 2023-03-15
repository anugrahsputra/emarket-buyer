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
        if (element.sellerId == cartModel.sellerId) {
          isExist = true;
          increaseQuantity(cartProducts.indexOf(element));
          break;
        } else {
          bool replaceItem = await _showBottomSheet();
          if (replaceItem) {
            cartProducts.remove(element);
            await _localDatabase.deleteProduct();
          }
          return;
        }
      }
    }

    if (!isExist) {
      bool hasItemsFromOtherSeller = cartProducts.any((element) =>
          element.sellerId != cartModel.sellerId &&
          element.productId != cartModel.productId);

      if (hasItemsFromOtherSeller) {
        bool replaceItem = await _showBottomSheet();
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

  _showBottomSheet() async {
    return await Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
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
                  onPressed: () {
                    Get.back(result: false);
                  },
                  child: const Text('Batalkan'),
                ),
                FilledButton(
                  onPressed: () {
                    Get.back(result: true);
                    ScaffoldMessenger.of(Get.context!).showSnackBar(
                      SnackBar(
                        content: const Center(
                          child: Text(
                            'Berhasil ditambahkan',
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(50),
                        duration: const Duration(milliseconds: 1500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    );
                  },
                  child: const Text('Ganti'),
                ),
              ],
            ),
          ],
        ),
      ),
      isDismissible: false,
    );
  }
}
