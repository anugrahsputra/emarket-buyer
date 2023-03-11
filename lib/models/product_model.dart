import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String sellerId;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  int price;
  int quantity;

  Product({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    this.price = 0,
    this.quantity = 0,
  });

  factory Product.fromSnapshot(DocumentSnapshot snap) {
    return Product(
      id: snap.id,
      sellerId: snap['sellerId'],
      name: snap['name'],
      description: snap['description'],
      category: snap['category'],
      imageUrl: snap['imageUrl'],
      price: snap['price'],
      quantity: snap['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerId': sellerId,
      'name': name,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  Product copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? category,
    String? description,
    String? imageUrl,
    int? price,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sellerId,
        name,
        category,
        description,
        imageUrl,
        price,
        quantity,
      ];

  String toJson() => json.encode(toMap());
}
