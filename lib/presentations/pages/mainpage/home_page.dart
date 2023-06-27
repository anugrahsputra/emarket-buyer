import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_buyer/common/formatter.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// *note: Need a better UX for this page
// todo: Make a list of Sellers instead of a list of Products

class Homepage extends StatelessWidget {
  Homepage({Key? key}) : super(key: key);

  final AuthController controller = Get.put(AuthController());
  final BuyerController buyerController = Get.put(BuyerController());
  final ProductController productController = Get.put(ProductController());
  final SellerController sellerController = Get.put(SellerController());
  final CartController cartController = Get.put(CartController());
  final List<String> categories = ['Makanan', 'Minuman'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Beranda'),
          centerTitle: true,
          leading: Obx(() {
            return IconButton(
              icon: productController.isGrid.value
                  ? const Icon(Icons.grid_view)
                  : const Icon(Icons.list),
              onPressed: () {
                productController.isGrid.toggle();
              },
            );
          }),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Container(
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12),
              child: TabBar(
                labelColor: Colors.white,
                splashFactory: NoSplash.splashFactory,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 68, 151, 76),
                ),
                tabs: categories.map((category) {
                  if (category == 'Makanan') {
                    return const Tab(
                      icon: Icon(Icons.food_bank_rounded),
                      // text: 'Makanan',
                    );
                  } else if (category == 'Minuman') {
                    return const Tab(
                      icon: Icon(Icons.local_drink_rounded),
                      // text: 'Minuman',
                    );
                  }
                  return Tab(text: category);
                }).toList(),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Obx(
                () => badges.Badge(
                  badgeContent: Text(
                    cartController.cartProducts.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  showBadge:
                      cartController.cartProducts.isNotEmpty ? true : false,
                  badgeAnimation: const badges.BadgeAnimation.rotation(
                    animationDuration: Duration(seconds: 1),
                    colorChangeAnimationDuration: Duration(seconds: 1),
                    loopAnimation: false,
                    curve: Curves.fastOutSlowIn,
                    colorChangeAnimationCurve: Curves.easeInCubic,
                  ),
                  child: const Icon(Icons.shopping_bag_rounded),
                ),
              ),
              onPressed: () {
                Get.toNamed('/cart-page');
              },
            ),
          ],
        ),
        body: TabBarView(
          children:
              categories.map((category) => buildProduct(category)).toList(),
        ),
      ),
    );
  }

  buildSellerList() {
    return Obx(() {
      return ListView.builder(
        itemCount: sellerController.sellers.length,
        itemBuilder: (context, index) {
          return Text(sellerController.sellers[index].displayName);
        },
      );
    });
  }

  Widget buildProduct(String filter) {
    return RefreshIndicator(
      onRefresh: productController.pullToRefresh,
      child: Obx(
        () {
          final filteredList = productController.product
              .where((product) => product.category == filter)
              .toList();
          return productController.isGrid.value
              ? GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: filteredList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        Get.to(
                          () => DetailPage(
                            product: filteredList[index],
                            seller: sellerController.sellers.firstWhere(
                              (element) =>
                                  element.id == filteredList[index].sellerId,
                              orElse: () => const SellerModel(),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GridTile(
                          key: ValueKey(filteredList[index].id),
                          footer: GridTileBar(
                              backgroundColor: Colors.black54,
                              title: Text(
                                filteredList[index].name,
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                Formatter.priceFormat(
                                    filteredList[index].price),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.shopping_cart_rounded),
                                onPressed: () {
                                  var storeName = sellerController.sellers
                                      .firstWhere(
                                          (element) =>
                                              element.id ==
                                              filteredList[index].sellerId,
                                          orElse: () => const SellerModel())
                                      .storeName;
                                  cartController.addProduct(
                                    CartModel(
                                      productId: filteredList[index].id,
                                      name: filteredList[index].name,
                                      price: filteredList[index].price,
                                      imageUrl: filteredList[index].imageUrl,
                                      sellerId: filteredList[index].sellerId,
                                      storeName: storeName,
                                    ),
                                  );
                                },
                              )),
                          child: CachedNetworkImage(
                            imageUrl: filteredList[index].imageUrl,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        Get.to(
                          () => DetailPage(
                            product: filteredList[index],
                            seller: sellerController.sellers.firstWhere(
                              (element) =>
                                  element.id == filteredList[index].sellerId,
                              orElse: () => const SellerModel(),
                            ),
                          ),
                        );
                      },
                      child: ProductCard(
                        key: ValueKey(filteredList[index].id),
                        seller: sellerController.sellers.firstWhere(
                          (element) =>
                              element.id == filteredList[index].sellerId,
                          orElse: () => const SellerModel(),
                        ),
                        product: filteredList[index],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  String greeting(BuyerModel? buyer) {
    var hour = DateTime.now().hour;
    var name = buyer?.displayName;
    if (hour < 12) {
      return 'Good Morning, $name';
    }
    if (hour < 15) {
      return 'Good Afternoon, $name';
    }
    if (hour < 18) {
      return 'Good Evening, $name';
    }
    return 'Good Evening, $name';
  }
}
