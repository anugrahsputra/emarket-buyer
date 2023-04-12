import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:equatable/equatable.dart';

class CheckoutModel extends Equatable {
  final String? id;
  final String buyerId;
  final String sellerId;
  final String displayName;
  final bool isProcessing;
  final bool isDelivered;
  final bool isCancelled;
  final List<CartModel> cart;
  final int total;
  final String date;
  final String note;
  const CheckoutModel({
    this.id,
    this.buyerId = '',
    this.sellerId = '',
    this.isProcessing = false,
    this.isDelivered = false,
    this.isCancelled = false,
    this.note = '',
    this.displayName = '',
    this.cart = const [],
    this.total = 0,
    this.date = '',
  });

  CheckoutModel copyWith({
    String? id,
    String? buyerId,
    String? sellerId,
    String? note,
    bool? isProcessing,
    bool? isDelivered,
    bool? isCancelled,
    String? displayName,
    List<CartModel>? cart,
    int? total,
    String? date,
  }) {
    return CheckoutModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      note: note ?? this.note,
      isProcessing: isProcessing ?? this.isProcessing,
      isCancelled: isCancelled ?? this.isCancelled,
      isDelivered: isDelivered ?? this.isDelivered,
      displayName: displayName ?? this.displayName,
      cart: cart ?? this.cart,
      total: total ?? this.total,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'note': note,
      'displayName': displayName,
      'isProcessing': isProcessing,
      'isCancelled': isCancelled,
      'isDelivered': isDelivered,
      'cart': cart.map((x) => x.toMap()).toList(),
      'total': total,
      'date': date,
    };
  }

  factory CheckoutModel.fromSnapshot(DocumentSnapshot map) {
    return CheckoutModel(
      id: map['id'],
      buyerId: map['buyerId'],
      sellerId: map['sellerId'],
      note: map['note'] ?? '',
      displayName: map['displayName'] ?? '',
      isProcessing: map['isProcessing'] ?? false,
      isDelivered: map['isDelivered'] ?? false,
      isCancelled: map['isCancelled'] ?? false,
      cart: List<CartModel>.from(map['cart']?.map((x) => CartModel.fromMap(x))),
      total: map['total']?.toInt() ?? 0,
      date: map['date'],
    );
  }

  @override
  List<Object> get props {
    return [
      buyerId,
      sellerId,
      displayName,
      isProcessing,
      isDelivered,
      isCancelled,
      note,
      cart,
      total,
      date,
    ];
  }
}
