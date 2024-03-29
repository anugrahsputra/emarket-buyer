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
      return BuyerModel.fromDocument(snapshot);
    } catch (e) {
      debugPrint(e.toString());
      return const BuyerModel();
    }
  }

  Future<bool?> updateBuyerInfo(
      String buyerId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('buyers').doc(buyerId).update(data);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Stream<List<BuyerModel>> fetchAllBuyers() {
    return _firestore.collection('buyers').snapshots().map((snapshot) {
      final buyersList =
          snapshot.docs.map((doc) => BuyerModel.fromDocument(doc)).toList();
      log('Fetched buyers: ${buyersList.length}');
      return buyersList;
    });
  }

  // seller
  Stream<List<SellerModel>> fetchAllSellers() {
    return _firestore.collection('sellers').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => SellerModel.fromDocument(doc)).toList());
  }

  Stream<List<Product>> fetchProductsBySellers(String sellerId) {
    return _firestore
        .collection('sellers')
        .doc(sellerId)
        .collection('products')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromDocument(doc)).toList());
  }

  // product stream
  Stream<List<Product>> fetchProducts() {
    return _firestore.collectionGroup('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromDocument(doc)).toList());
  }

  Future<void> productRating(String sellerId, String productId,
      double newRating, int newNumRating) async {
    try {
      await _firestore
          .collection('sellers')
          .doc(sellerId)
          .collection('products')
          .doc(productId)
          .update({
        'rating': newRating,
        'numRatings': newNumRating,
      });
    } catch (e) {
      debugPrint('Database.updateProductRating: $e');
      rethrow;
    }
  }

  Future<bool?> addComment(ProductCommentModel comment) async {
    try {
      await _firestore
          .collection('sellers')
          .doc(comment.sellerId)
          .collection('products')
          .doc(comment.productId)
          .collection('comment')
          .doc(comment.id)
          .set(comment.toDocument());
      log('database service: comment added');
      return true;
    } catch (e) {
      log('database service: error adding comment $e');
      return false;
    }
  }

  Stream<List<ProductCommentModel>> fetchComment() {
    return _firestore.collectionGroup('comment').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => ProductCommentModel.fromDocument(doc))
            .toList());
  }

  Future<void> searchProducts(String searchText) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collectionGroup('products')
          .where('name', isGreaterThanOrEqualTo: searchText)
          .where('name', isLessThanOrEqualTo: '$searchText\uf8ff')
          .get();
      snapshot.docs.map((doc) => Product.fromDocument(doc)).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
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

  Future<bool?> saveToken(String buyerId, String token) async {
    try {
      await _firestore.collection('buyers').doc(buyerId).update({
        'tokens': FieldValue.arrayUnion([token])
      });
      return true;
    } catch (e) {
      debugPrint('save token error: ${e.toString()}');
      return false;
    }
  }

  // checkout
  Future<void> newCheckout(CheckoutModel checkout, String id) async {
    try {
      await _firestore
          .collection('buyers')
          .doc(id)
          .collection('checkout')
          .doc(checkout.id)
          .set(checkout.toMap());
      log('New checkout created to database');
    } catch (e) {
      log('Error creating new checkout to database: ${e.toString()}');
      rethrow;
    }
  }

  Stream<List<CheckoutModel>> fetchCheckout(String id) {
    return _firestore
        .collection('buyers')
        .doc(id)
        .collection('checkout')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CheckoutModel.fromDocument(doc))
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
            .map((doc) => CheckoutModel.fromDocument(doc))
            .toList());
  }

  Future<void> updateCheckoutStatus(
    CheckoutModel checkout,
    Map<String, dynamic> data,
  ) async {
    return _firestore
        .collection('buyers')
        .doc(checkout.buyerId)
        .collection('checkout')
        .where('id', isEqualTo: checkout.id)
        .get()
        .then((querySnaphot) => querySnaphot.docs.first.reference.update(data));
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
