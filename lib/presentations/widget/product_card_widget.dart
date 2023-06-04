// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_buyer/common/formatter.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    Key? key,
    required this.product,
    required this.seller,
  }) : super(key: key);

  final Product product;
  final SellerModel seller;

  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  Database database = Database();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
      ),
      child: Card(
        color: const Color(0xffdee2e6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image(
                  image: CachedNetworkImageProvider(
                    product.imageUrl,
                  ),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Text(
                        Formatter.priceFormat(product.price),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  cartController.addProduct(CartModel(
                      name: product.name,
                      sellerId: product.sellerId,
                      price: product.price,
                      productId: product.id,
                      imageUrl: product.imageUrl,
                      storeName: seller.storeName));
                },
                icon: const Icon(Icons.add_shopping_cart),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
