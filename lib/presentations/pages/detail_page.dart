import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    Key? key,
    required this.product,
    required this.seller,
  }) : super(key: key);
  static const String routeName = '/detail-page';
  final Product product;
  final SellerModel seller;

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());
    final BuyerController buyerController = Get.put(BuyerController());

    final sellerProducts = controller.product
        .where((product) => product.sellerId == seller.id)
        .toList();
    final comments = controller.productComment
        .where((comment) => comment.productId == product.id)
        .toList();

    final CartController cartController = Get.put(CartController());
    debugPrint('Seller: ${seller.storeName}');
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(95.h),
              child: Container(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 20.w,
                  bottom: 10.w,
                ),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color:
                      ColorScheme.fromSeed(seedColor: const Color(0xffa1cca5))
                          .background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rp. ${product.price}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: product.rating,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                            Text('(${product.numRatings})'),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.store,
                                size: 16,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                seller.storeName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Get.toNamed('/seller-page', arguments: seller);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 10.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ExpandedText(
                    text: product.description,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  sellerProducts.length <= 1
                      ? const SizedBox()
                      : Text(
                          'Produk lainnya dari ${seller.storeName}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ),
          ),
          sellerProducts.length <= 1
              ? const SliverToBoxAdapter()
              : SliverToBoxAdapter(
                  child: SizedBox(
                    width: double.infinity,
                    child: GetX<ProductController>(
                      builder: (productController) {
                        if (productController.loading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(
                              left: 24.w,
                              right: 24.w,
                              bottom: 24.h,
                            ),
                            height: 150.h,
                            width: 80.w,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: sellerProducts.length,
                              itemBuilder: (context, index) {
                                final product = sellerProducts[index];
                                if (product.id == this.product.id) {
                                  return const SizedBox();
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                            product: product,
                                            seller: seller,
                                          ),
                                        ),
                                      );
                                    },
                                    child: RecommendCard(product: product),
                                  );
                                }
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 10.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ulasan (${comments.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      final buyer = buyerController.buyers.firstWhere(
                          (buyer) => buyer.id == comment.buyerId,
                          orElse: () => const BuyerModel());
                      return Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 52.w,
                              height: 52.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(buyer.photoUrl),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  buyer.displayName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                RatingBarIndicator(
                                  rating: comment.rating,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 14.0,
                                  direction: Axis.horizontal,
                                ),
                                SizedBox(height: 8.h),
                                Text(comment.comment),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 20.w,
        ),
        child: FilledButton.icon(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
              Size(170.w, 50.h),
            ),
          ),
          onPressed: () {
            cartController.addProduct(
              CartModel(
                sellerId: seller.id,
                name: product.name,
                productId: product.id,
                price: product.price,
                storeName: seller.storeName,
                imageUrl: product.imageUrl,
              ),
            );
          },
          icon: const Icon(
            Icons.shopping_bag,
          ),
          label: const Text('Masukan Keranjang'),
        ),
      ),
    );
  }
}
