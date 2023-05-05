import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key, required this.buyer}) : super(key: key);

  final BuyerModel buyer;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final BuyerController buyerController = Get.put(BuyerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(buyer.photoUrl),
              ),
            ),
            const SizedBox(height: 20),
            Fields(
              controller: nameController,
              keyboardType: TextInputType.name,
              hintText: buyer.displayName,
              prefixIcon: const Icon(
                Icons.person,
                color: Color(0xff495057),
              ),
            ),
            const SizedBox(height: 20),
            Fields(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              hintText: buyer.phoneNumber,
              prefixIcon: const Icon(
                Icons.phone,
                color: Color(0xff495057),
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
              onPressed: () {
                if (nameController.text.isNotEmpty ||
                    phoneController.text.isNotEmpty ||
                    addressController.text.isNotEmpty) {
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
                  buyerController.updateUserInfo(data);
                }
                Get.back();
              },
              title: 'Simpan',
            )
          ],
        ),
      ),
    );
  }
}
