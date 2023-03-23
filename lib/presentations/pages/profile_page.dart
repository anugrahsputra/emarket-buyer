import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profilepage extends StatelessWidget {
  Profilepage({Key? key}) : super(key: key);

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Center(
        child: FilledButton(
          child: const Text('Sign Out'),
          onPressed: () async {
            authController.signOut();
          },
        ),
      ),
    );
  }
}
