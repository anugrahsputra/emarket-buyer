import 'package:emarket_buyer/models/model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(24),
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
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  checkout.isCancelled
                      ? const Text('Cancelled')
                      : checkout.isDelivered
                          ? Text(
                              'Sudah diterima',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                              ),
                            )
                          : checkout.isProcessing
                              ? const Text('Diproses')
                              : const Text('Pesanan Masuk'),
                ],
              ),
              Text(
                seller.storeName,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.black,
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        checkout.cart[index].price.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                      trailing: Text(
                        checkout.cart[index].quantity.toString(),
                        style: GoogleFonts.poppins(
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
    );
  }
}
