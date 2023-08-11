import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OrderHistoryWidget extends StatelessWidget {
  const OrderHistoryWidget({
    super.key,
    required this.checkout,
    required this.seller,
  });

  final CheckoutModel checkout;
  final SellerModel seller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => OrderDetailPage(
              checkout: checkout,
              seller: seller,
            ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 10.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      checkout.date,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Ternary operator to death >:(
                      backgroundColor: checkout.isCancelled == true
                          ? Colors.red[200]
                          : checkout.isDelivered == true
                              ? Colors.green[200]
                              : checkout.isShipping == true
                                  ? Colors.orange[200]
                                  : checkout.isProcessing == true
                                      ? Colors.blue[200]
                                      : Colors.grey[200],
                      label: Text(
                        checkout.isCancelled == true
                            ? 'Dibatalkan'
                            : checkout.isDelivered == true
                                ? 'Selesai'
                                : checkout.isShipping == true
                                    ? 'Dikirim'
                                    : checkout.isProcessing == true
                                        ? 'Diproses'
                                        : 'Pesanan Masuk',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      MdiIcons.store,
                      size: 18.sp,
                    ),
                    SizedBox(width: 2.5.w),
                    Text(
                      seller.storeName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            const Divider(
              color: Colors.black,
            ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                childrenPadding: const EdgeInsets.all(0),
                title: Text('Item (${checkout.cart.length})'),
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: checkout.cart.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(
                          checkout.cart[index].imageUrl,
                        ),
                        title: Text(
                          checkout.cart[index].name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          checkout.cart[index].price.toString(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                          ),
                        ),
                        trailing: Text(
                          checkout.cart[index].quantity.toString(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
