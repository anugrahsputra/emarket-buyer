import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/formatter.dart';

class CartCard extends StatelessWidget {
  CartCard({
    super.key,
    required this.cartModel,
    required this.onPressedMin,
    required this.onPressedPlus,
  });

  final CartModel cartModel;
  final CartController cartController = Get.put(CartController());
  final VoidCallback onPressedMin, onPressedPlus;
  final int index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 110,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(
        left: 10,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffdee2e6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image(
              image: NetworkImage(
                cartModel.imageUrl,
              ),
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cartModel.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                ),
                Text(
                  cartModel.storeName,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  Formatter.priceFormat(cartModel.price * cartModel.quantity),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                IconButton(
                  onPressed: onPressedMin,
                  icon: const Icon(
                    Icons.remove,
                  ),
                  iconSize: 20,
                ),
                Text(
                  cartModel.quantity.toString(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: onPressedPlus,
                  icon: const Icon(
                    Icons.add,
                  ),
                  iconSize: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
