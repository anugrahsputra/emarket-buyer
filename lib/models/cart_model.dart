import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  late String name;
  late String productId;
  late int price;
  late String imageUrl;
  late String storeName;
  late int quantity;
  CartModel({
    required this.name,
    required this.productId,
    this.price = 1,
    required this.imageUrl,
    required this.storeName,
    this.quantity = 1,
  });

  CartModel copyWith({
    String? name,
    String? productId,
    int? price,
    String? imageUrl,
    String? storeName,
    int? quantity,
  }) {
    return CartModel(
      name: name ?? this.name,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      storeName: storeName ?? this.storeName,
      quantity: quantity ?? this.quantity,
    );
  }

  toMap() {
    return {
      'name': name,
      'productId': productId,
      'price': price,
      'imageUrl': imageUrl,
      'storeName': storeName,
      'quantity': quantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      name: map['name'] ?? '',
      productId: map['productId'] ?? '',
      price: int.parse(map['price'].toString()), // add a default value of 0
      imageUrl: map['imageUrl'] ?? '',
      storeName: map['storeName'] ?? '',
      quantity: int.parse(map['quantity'].toString()),
    );
  }

  @override
  List<Object> get props {
    return [
      name,
      productId,
      price,
      imageUrl,
      storeName,
      quantity,
    ];
  }
}
