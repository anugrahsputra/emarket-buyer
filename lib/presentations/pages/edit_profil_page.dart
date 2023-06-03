import 'dart:io';

import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:emarket_buyer/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key, required this.buyer}) : super(key: key);

  final BuyerModel buyer;
  final storage = Storage();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final buyerController = Get.put(BuyerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit profil'),
        leading: IconButton(
          onPressed: () {
            Get.back();
            buyerController.newProfilePicture.value = null;
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                child: Obx(() {
                  final newProPic = buyerController.newProfilePicture.value;
                  return newProPic != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(File(newProPic.path)),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(buyerController.buyer.photoUrl));
                }),
                onTap: () {
                  buyerController.selectNewProfilePicture();
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                hintText: buyer.displayName,
                prefixIcon: const Icon(
                  Icons.person,
                  color: Color(0xff495057),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    style: BorderStyle.none,
                    width: 0,
                  ),
                ),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: buyer.phoneNumber,
                prefixIcon: const Icon(
                  Icons.phone,
                  color: Color(0xff495057),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    style: BorderStyle.none,
                    width: 0,
                  ),
                ),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: addressController,
              keyboardType: TextInputType.streetAddress,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: buyer.address,
                prefixIcon: const Icon(
                  Icons.home,
                  color: Color(0xff495057),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    style: BorderStyle.none,
                    width: 0,
                  ),
                ),
                filled: true,
              ),
            ),
            const Spacer(),
            ButtonWidget(
              onPressed: () async {
                Map<String, dynamic> data = {
                  'displayName': nameController.text.isNotEmpty
                      ? nameController.text
                      : buyer.displayName,
                  'phoneNumber': phoneController.text.isNotEmpty
                      ? phoneController.text
                      : buyer.phoneNumber,
                  'address': addressController.text.isNotEmpty
                      ? addressController.text
                      : buyer.address,
                };
                await buyerController.updateUserInfo(data);
                await buyerController.uploadProfilePic();
                await buyerController.fetchBuyer();
                Get.back(
                  result: 'success',
                  canPop: false,
                );
                buyerController.update();
              },
              title: 'Simpan',
            )
          ],
        ),
      ),
    );
  }
}
