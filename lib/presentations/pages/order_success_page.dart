import 'package:emarket_buyer/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessPage extends StatelessWidget {
  OrderSuccessPage({Key? key}) : super(key: key);
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Placed Successfully',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                Get.offNamedUntil('/main-page', (route) => false);
                cartController.cartProducts.clear();
                cartController.update();
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
