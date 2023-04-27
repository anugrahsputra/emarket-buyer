import 'dart:developer';

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

  Future<bool?> updateProduct(
    String sellerId,
    String productId,
    String field,
    dynamic value,
  ) async {
    try {
      await _firestore
          .collection('sellers')
          .doc(sellerId)
          .collection('products')
          .doc(productId)
          .update({field: value});
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // cart

  // checkout
  Future<void> newCheckout(CheckoutModel checkout, String id) {
    return _firestore
        .collection('buyers')
        .doc(id)
        .collection('checkout')
        .doc(checkout.id)
        .set(checkout.toMap());
  }

  Stream<List<CheckoutModel>> fetchCheckout(String id) {
    return _firestore
        .collection('buyers')
        .doc(id)
        .collection('checkout')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CheckoutModel.fromSnapshot(doc))
            .toList());
  }

  Stream<List<CheckoutModel>> fetchCheckoutIsdone(String id, bool isDone) {
    return _firestore
        .collection('buyers')
        .doc(id)
        .collection('checkout')
        .where('isDelivered', isEqualTo: isDone)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CheckoutModel.fromSnapshot(doc))
            .toList());
  }

  Future<void> updateCheckoutStatus(
    CheckoutModel checkout,
    String field,
    bool newValue,
  ) async {
    return _firestore
        .collection('buyers')
        .doc(checkout.buyerId)
        .collection('checkout')
        .where('id', isEqualTo: checkout.id)
        .get()
        .then((querySnaphot) =>
            querySnaphot.docs.first.reference.update({field: newValue}));
  }

  Future<void> updateUserLocation(BuyerModel buyer, LocationModel location,
      String field, dynamic newValue) async {
    return _firestore
        .collection('buyers')
        .doc(buyer.id)
        .update({field: newValue});
  }

  Future<void> updateUserAddress(
      BuyerModel buyer, String field, dynamic newValue) async {
    return _firestore
        .collection('buyers')
        .doc(buyer.id)
        .update({field: newValue});
  }

  void dispose() {
    _firestore.terminate();
  }
}
