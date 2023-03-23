import 'dart:developer';

import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class BuyerController extends GetxController {
  final Rx<BuyerModel> _buyer = const BuyerModel().obs;
  final Database database = Database();

  final loading = false.obs;

  BuyerModel get buyer => _buyer.value;

  set buyer(BuyerModel value) {
    _buyer.value = value;
  }

  void clear() {
    _buyer.value = const BuyerModel();
  }

  @override
  void onReady() {
    super.onReady();
    fetchBuyer();
  }

  fetchBuyer() async {
    try {
      loading.value = true;
      final User user = FirebaseAuth.instance.currentUser!;
      buyer = await database.getBuyer(user.uid);
    } catch (e) {
      print(e);
    } finally {
      loading.value = false;
    }
  }

  updateUserLocation(LocationModel location, String address) async {
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
      log('Error updating buyer location: $e');
      rethrow;
    }
  }
}
