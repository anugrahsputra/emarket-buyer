import 'package:emarket_buyer/models/product_model.dart';
import 'package:flutter/material.dart';

class RecommendCard extends StatelessWidget {
  const RecommendCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image(
              image: NetworkImage(
                product.imageUrl,
              ),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            'Rp. ${product.price}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
