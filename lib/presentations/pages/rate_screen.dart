import 'dart:async';
import 'dart:developer';

import 'package:emarket_buyer/common/formatter.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'main_page.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key, required this.checkout, required this.seller});

  final CheckoutModel checkout;
  final SellerModel seller;

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  final ProductController productController = Get.put(ProductController());
  List<double> productRating = [];

  // @override
  // void initState() {
  //   super.initState();
  // Initialize productRatings with default ratings (e.g., 3) for each product
  //   productRating = List<double>.filled(widget.checkout.cart.length, 0);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Get.offAll(
                      () => const MainPage(initialIndex: 1),
                      transition: Transition.upToDown,
                      predicate: (route) => false,
                    );
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              SizedBox(height: 15.h),
              Lottie.asset('assets/lottie/rate.json', width: 256.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  'Kasih rating untuk produk yang kamu beli ya',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Geser ke kiri jika kamu beli lebih dari 1 produk',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 150.h,
                child: ListView.builder(
                  itemCount: widget.checkout.cart.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final cart = widget.checkout.cart[index];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                      child: Card(
                        shadowColor: Colors.black,
                        color: Colors.white,
                        child: SizedBox(
                          width: 300.w,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        image: NetworkImage(cart.imageUrl),
                                        width: 54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cart.name,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(Formatter.priceFormat(cart.price)),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(),
                                RatingBar.builder(
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 30,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    if (productRating.length <= index) {
                                      productRating.add(rating);
                                    } else {
                                      productRating[index] = rating;
                                    }
                                    log(rating.toString());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              FilledButton(
                onPressed: () {
                  if (productRating.length == widget.checkout.cart.length) {
                    for (int i = 0; i < widget.checkout.cart.length; i++) {
                      final cart = widget.checkout.cart[i];
                      final rating = productRating[i];
                      productController.rateProduct(
                        widget.seller.id,
                        cart.productId,
                        rating,
                      );
                    }
                    productRating.clear();
                    Get.offAll(
                      () => const ThankYouScreen(),
                    );
                  }
                },
                child: Text(
                  'Submit',
                  style:
                      GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({super.key});

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),
      () {
        Get.offAll(() => const MainPage(initialIndex: 1),
            predicate: (route) => false, transition: Transition.upToDown);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 103, 233, 107),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Makasih ya!',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'Rating mu akan sangat membantu untuk para penjual',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            )
          ],
        ),
      )),
    );
  }
}
