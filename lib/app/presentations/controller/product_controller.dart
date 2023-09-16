import 'dart:developer';

import 'package:emarket_buyer/app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/model.dart';

class ProductController extends GetxController {
  final Database database = Database();
  RxBool loading = false.obs;
  RxBool isGrid = true.obs;
  var uuid = const Uuid();
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  final product = RxList<Product>([]);
  final productBySeller = RxList<Product>([]);
  final productComment = RxList<ProductCommentModel>([]);

  var newComment = <ProductCommentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
    getComment();
  }

  void setLoading(bool value) {
    loading.value = value;
    update();
  }

  void getProducts() async {
    try {
      setLoading(true);
      product.bindStream(database.fetchProducts());
      setLoading(false);
    } catch (e) {
      setLoading(false);
      debugPrint('ProductController.fetchProducts: $e');
    }
  }

  void getComment() async {
    try {
      setLoading(true);
      productComment.bindStream(database.fetchComment());
      setLoading(false);
    } catch (e) {
      log('error get comment: $e');
      setLoading(false);
    }
  }

  void rateProduct(String sellerId, String productId, double rating) async {
    try {
      setLoading(true);
      final selectedProduct =
          product.firstWhere((product) => product.id == productId);
      final newRating =
          (selectedProduct.rating * selectedProduct.numRatings + rating) /
              (selectedProduct.numRatings + 1);
      final newNumRating = selectedProduct.numRatings + 1;
      await database.productRating(
          sellerId, productId, newRating, newNumRating);
      getProducts();
    } catch (e) {
      debugPrint('ProductController.rateProduct: $e');
    }
  }

  void addProductComment({
    required String sellerId,
    required String buyerId,
    required String buyerName,
    required String productId,
    required String newComment,
    required double rating,
  }) async {
    try {
      ProductCommentModel comment = ProductCommentModel(
        id: uuid.v4(),
        buyerName: buyerName,
        buyerId: buyerId,
        productId: productId,
        sellerId: sellerId,
        comment: newComment,
        timestamp: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        rating: rating,
      );
      await database.addComment(comment);
    } catch (e) {
      log('erro adding comment: $e');
      rethrow;
    }
  }

  Future<void> pullToRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    getProducts();
  }

  @override
  void dispose() {
    product.close();
    database.dispose();
    super.dispose();
  }
}
