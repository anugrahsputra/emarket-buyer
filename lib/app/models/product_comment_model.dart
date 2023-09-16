import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductCommentModel extends Equatable {
  final String id;
  final String buyerName;
  final String buyerId;
  final String productId;
  final String sellerId;
  final String comment;
  final String timestamp;
  final double rating;
  const ProductCommentModel({
    required this.id,
    required this.buyerName,
    required this.buyerId,
    required this.productId,
    required this.sellerId,
    required this.comment,
    required this.timestamp,
    this.rating = 0,
  });

  factory ProductCommentModel.fromDocument(DocumentSnapshot snap) {
    return ProductCommentModel(
      id: snap.id,
      buyerName: snap['buyerName'],
      buyerId: snap['buyerId'],
      productId: snap['productId'],
      sellerId: snap['sellerId'],
      comment: snap['comment'],
      timestamp: snap['timestamp'],
      rating: snap['rating'],
    );
  }

  Map<String, dynamic> toDocument() => {
        'id': id,
        'buyerName': buyerName,
        'buyerId': buyerId,
        'productId': productId,
        'sellerId': sellerId,
        'comment': comment,
        'timestamp': timestamp,
        'rating': rating,
      };

  ProductCommentModel copyWith({
    String? id,
    String? buyerName,
    String? buyerId,
    String? productId,
    String? sellerId,
    String? comment,
    String? timestamp,
    double? rating,
  }) =>
      ProductCommentModel(
        id: id ?? this.id,
        buyerName: buyerName ?? this.buyerName,
        buyerId: buyerId ?? this.buyerId,
        productId: productId ?? this.productId,
        sellerId: sellerId ?? this.sellerId,
        comment: comment ?? this.comment,
        timestamp: timestamp ?? this.timestamp,
        rating: rating ?? this.rating,
      );

  @override
  List<Object?> get props => [
        id,
        buyerId,
        buyerName,
        productId,
        sellerId,
        comment,
        timestamp,
        rating,
      ];
}
