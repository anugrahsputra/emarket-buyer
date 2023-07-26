import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends GetWidget<QueryController> {
  SearchPage({Key? key}) : super(key: key);
  final SellerController sellerController = Get.find<SellerController>();
  final TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cari',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 13.w,
              right: 13.w,
              bottom: 10.h,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: queryController,
                  onChanged: (value) {
                    String lowerCase = value.toLowerCase();
                    controller.updateQuery(lowerCase);
                  },
                  decoration: const InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                    hintText: 'Cari barang',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  String lowerCasePattern = pattern.toLowerCase();
                  return await controller.getSuggestion(lowerCasePattern);
                },
                itemBuilder: (context, itemData) {
                  return ListTile(
                    title: Text(itemData),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  );
                },
                onSuggestionSelected: (selected) {
                  queryController.text = selected;
                  String lowerCase = selected.toLowerCase();
                  controller.updateQuery(lowerCase);
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return buildSearchLoading();
              } else {
                if (controller.queryString.isEmpty) {
                  return Center(
                    child: Text(
                      'Cari produk yang kamu mau',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                } else if (controller.searchResult.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/no_result.json',
                          width: 150.w),
                      Text(
                        'Aduh, ${queryController.text} sepertinya belum ada :(',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.searchResult.length,
                    itemBuilder: (context, index) {
                      final product = controller.searchResult[index];
                      final seller = sellerController.sellers.firstWhere(
                        (seller) => seller.id == product.sellerId,
                        orElse: () => const SellerModel(),
                      );
                      return GestureDetector(
                        onTap: () {
                          Get.to(() =>
                              DetailPage(product: product, seller: seller));
                        },
                        child: ProductCard(product: product, seller: seller),
                      );
                    },
                  );
                }
              }
            }),
          ),
        ],
      ),
    );
  }

  buildSearchLoading() {
    return Center(
      child: Lottie.asset(
        'assets/lottie/search.json',
      ),
    );
  }
}
