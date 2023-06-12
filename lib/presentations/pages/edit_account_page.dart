import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';

class EditAccountPage extends StatelessWidget {
  EditAccountPage({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final buyerController = Get.put(BuyerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Account',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                  title: 'Masukan password',
                  content: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  textConfirm: 'Konfirmasi',
                  onConfirm: () async {
                    await buyerController.updateUserAccoount(
                        emailController.text.trim(),
                        passwordController.text.trim());
                    await buyerController.fetchBuyer();
                    Get.back();
                    Get.back();
                  });
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Obx(
        () => buyerController.loading.value
            ? Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffe9ecef),
                    ),
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: buyerController.buyer.email,
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
