import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication
  Future<bool> createNewBuyer(BuyerModel buyer) async {
    try {
      await _firestore
          .collection('buyers')
          .doc(buyer.id)
          .set(buyer.toDocument());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<BuyerModel> getBuyer(String id) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('buyers').doc(id).get();
      return BuyerModel.fromSnapshot(snapshot);
    } catch (e) {
      debugPrint(e.toString());
      return const BuyerModel();
    }
  }

  // seller
  Stream<List<SellerModel>> fetchAllSellers() {
    return _firestore.collection('sellers').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => SellerModel.fromSnapshot(doc)).toList());
  }

  // product stream
  Stream<List<Product>> fetchAllProducts() {
    return _firestore.collectionGroup('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList());
  }

  // product spesific seller
  Stream<List<Product>> getProduct(String id) {
    return _firestore
        .collection('sellers')
        .doc(id)
        .collection('products')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList());
  }
}
