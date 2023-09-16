import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_buyer/app/common/formatter.dart';
import 'package:emarket_buyer/app/models/model.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:emarket_buyer/app/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// *note: Need a better UI for this page

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final AuthController controller = Get.put(AuthController());

  final BuyerController buyerController = Get.put(BuyerController());

  final ProductController productController = Get.put(ProductController());

  final SellerController sellerController = Get.put(SellerController());

  final CartController cartController = Get.put(CartController());

  final List<String> categories = ['Semua', 'Makanan', 'Minuman'];

  String selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    final MainPageController mainPageController =
        Get.find<MainPageController>();
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  mainPageController.changePage(3);
                },
                child: Obx(
                  () => CircleAvatar(
                    radius: 24,
                    backgroundImage: CachedNetworkImageProvider(
                      buyerController.buyer.photoUrl,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Obx(() => Text(greeting(buyerController))),
            ],
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
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(() {
                    return IconButton(
                      icon: productController.isGrid.value
                          ? const Icon(Icons.grid_view)
                          : const Icon(Icons.list),
                      onPressed: () {
                        productController.isGrid.toggle();
                      },
                    );
                  }),
                ),
                Wrap(
                    spacing: 6.w,
                    children: categories.map((category) {
                      return FilterChip(
                        showCheckmark: false,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0.r),
                        ),
                        backgroundColor: Colors.black12,
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (isSelected) {
                          setState(() {
                            selectedCategory = isSelected ? category : 'Semua';
                          });
                        },
                      );
                    }).toList()),
              ],
            ),
            Expanded(
              child: buildProduct(selectedCategory),
            ),
          ],
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
              .where(
                  (product) => filter == 'Semua' || product.category == filter)
              .toList();
          return productController.isGrid.value
              ? GridView.builder(
                  shrinkWrap: true,
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
                        borderRadius: BorderRadius.circular(10.r),
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
                  shrinkWrap: true,
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

  String greeting(BuyerController buyer) {
    var hour = DateTime.now().hour;
    var name = buyer.buyer.displayName;
    if (hour < 12) {
      return 'Selamat Pagi, \n$name';
    }
    if (hour < 15) {
      return 'Selamat Siang, \n$name';
    }
    if (hour < 18) {
      return 'Selamat Malam, \n$name';
    }
    return 'Selamat Malam, \n$name';
  }
}
