import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    Key? key,
    required this.product,
    required this.seller,
  }) : super(key: key);
  final Product product;
  final SellerModel seller;

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());
    final sellerProducts = controller.product
        .where((product) => product.sellerId == seller.id)
        .toList();
    final CartController cartController = Get.put(CartController());
    debugPrint('Seller: ${seller.storeName}');
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(95),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 20,
                  bottom: 10,
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.store,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              seller.storeName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 10,
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
                  const SizedBox(
                    height: 10,
                  ),
                  ExpandedText(
                    text: product.description,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
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
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: GetX<ProductController>(
                builder: (productController) {
                  if (productController.product.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada produk'),
                    );
                  } else if (productController.loading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      height: 125,
                      width: 80,
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
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: FilledButton.icon(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
              const Size(170, 50),
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

            debugPrint('Cart: ${cartController.cartProducts.length}');
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
