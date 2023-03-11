import 'package:emarket_buyer/models/buyer_model.dart';
import 'package:emarket_buyer/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _firebaseUser = Rxn<User>();
  final loading = false.obs;

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  void createBuyer(String displayName, String email, String photoUrl,
      String password) async {
    try {
      loading.value = true;
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      BuyerModel buyer = BuyerModel(
        id: credential.user!.uid,
        displayName: displayName,
        email: email,
        photoUrl: photoUrl,
      );
      if (await Database().createNewBuyer(buyer)) {
        Get.find<BuyerController>().buyer = buyer;
        Get.find<ProductController>().update();
        Get.back();
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        "Error creating Account",
        'Mohon Diisi Dengan Benar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff343a40),
        colorText: const Color(0xfff8f9fa),
        duration: const Duration(seconds: 3),
        forwardAnimationCurve: Curves.easeOutBack,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  void signIn(String email, String password) async {
    try {
      loading.value = true;
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      Get.find<BuyerController>().buyer =
          await Database().getBuyer(credential.user!.uid);
      Get.find<BuyerController>().update();
      Get.find<ProductController>().update();
      debugPrint(credential.toString());
      Get.back();
      loading.value = false;
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        "Error signing in",
        "check your email and password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff343a40),
        colorText: const Color(0xfff8f9fa),
        duration: const Duration(seconds: 3),
        forwardAnimationCurve: Curves.easeInOut,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  void signOut() async {
    try {
      if (_auth.currentUser != null) {
        await _auth.signOut();
        Get.find<BuyerController>().clear();
      }
      // Get.find<ProductController>().clearProducts();
    } catch (e, stackTrace) {
      debugPrint('Error signing out: $e');
      debugPrint(stackTrace.toString());
      Get.snackbar(
        "Error signing out",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _firebaseUser.close();
    super.dispose();
  }
}
