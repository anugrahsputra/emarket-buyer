import 'package:emarket_buyer/controller/controller.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
      height: 110,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffdee2e6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartModel.name,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                cartModel.storeName,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Rp. ${cartModel.price * cartModel.quantity}',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                onPressed: onPressedMin,
                icon: const Icon(
                  Icons.remove,
                ),
              ),
              Text(
                cartModel.quantity.toString(),
                style: GoogleFonts.roboto(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: onPressedPlus,
                icon: const Icon(
                  Icons.add,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
