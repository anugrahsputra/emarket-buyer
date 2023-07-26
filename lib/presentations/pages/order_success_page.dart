import 'dart:async';

import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OrderSuccessPage extends StatefulWidget {
  const OrderSuccessPage({Key? key}) : super(key: key);

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),
      () {
        Get.offAll(
          () => const MainPage(initialIndex: 1),
          predicate: (route) => false,
        );
        cartController.cartProducts.clear();
        cartController.update();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/checkout.json',
                width: 200.w, height: 200.w, repeat: false),
            const SizedBox(height: 20),
            const Text(
              'Order Placed Successfully',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 20),
            // FilledButton(
            //   onPressed: () {
            //     Get.offAll(
            //       () => const MainPage(initialIndex: 1),
            //       predicate: (route) => false,
            //     );
            //     cartController.cartProducts.clear();
            //     cartController.update();
            //   },
            //   child: const Text('Continue Shopping'),
            // ),
          ],
        ),
      ),
    );
  }
}
