// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:emarket_buyer/app/models/model.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:emarket_buyer/app/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BuyerController extends GetxController {
  final Rx<BuyerModel> _buyer = const BuyerModel().obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Database database = Database();
  final loading = false.obs;
  RxDouble uploadProgress = 0.0.obs;

  Rx<XFile?> newProfilePicture = Rx<XFile?>(null);

  final buyers = RxList<BuyerModel>([]);

  BuyerModel get buyer => _buyer.value;

  set buyer(BuyerModel value) {
    _buyer.value = value;
  }

  void clear() {
    _buyer.value = const BuyerModel();
  }

  @override
  void onInit() {
    super.onInit();
    fetchBuyer();
    fetchAllBuyer();
  }

  setLoading(bool value) {
    loading.value = value;
    update();
  }

  Future<void> fetchAllBuyer() async {
    try {
      setLoading(true);
      buyers.bindStream(database.fetchAllBuyers());
      setLoading(false);
    } catch (e) {
      log('Error fetching all buyers: $e');
      setLoading(false);
    }
  }

  Future<void> fetchBuyer() async {
    try {
      setLoading(true);
      final User user = FirebaseAuth.instance.currentUser!;
      buyer = await database.getBuyer(user.uid);
      update();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateUserLocation(
      LocationModel location, String address) async {
    try {
      buyer = buyer.copyWith(location: location, address: address);
      await database.updateUserLocation(
        buyer,
        location,
        'location',
        location.toMap(),
      );
      await database.updateUserAddress(buyer, 'address', address);
    } catch (e) {
      debugPrint('Error updating buyer location: $e');
      rethrow;
    }
  }

  Future<void> updateUserInfo(Map<String, dynamic> data) async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      await database.updateBuyerInfo(id, data);
    } catch (e) {
      debugPrint('Error updating buyer info: $e');
      rethrow;
    }
  }

  Future<void> updateUserAccoount(String email, String password) async {
    try {
      setLoading(true);
      final user = _auth.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updateEmail(email);
      await updateUserInfo({'email': email.isEmpty ? buyer.email : email});
      update();
    } catch (e) {
      debugPrint('Error updating account: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> selectNewProfilePicture() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        newProfilePicture.value = image;
      } else {
        debugPrint('No image selected');
      }
    } catch (e) {
      debugPrint('Error selecting new profile picture: $e');
    }
  }

  Future<void> uploadProfilePic() async {
    try {
      if (newProfilePicture == null) {
        debugPrint('No new profile picture selected');
        return;
      } else {
        setLoading(true);
        final storage = Storage();
        final url = await storage.uploadProfileImage(newProfilePicture.value!,
            (progress) => uploadProgress.value = progress);
        Map<String, dynamic> photoUrl = {
          'photoUrl': newProfilePicture.value == null ? buyer.photoUrl : url,
        };
        updateUserInfo(photoUrl);
        update();
        setLoading(false);
      }
    } catch (e) {
      debugPrint('Error uploading profile picture: $e');
      rethrow;
    }
  }
}
