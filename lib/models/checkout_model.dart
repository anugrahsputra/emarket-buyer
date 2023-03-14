import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class CheckoutModel extends Equatable {
  final String? id;
  final String displayName;
  final bool isProcessing;
  final bool isDelivered;
  final List<CartModel> cart;
  final int total;
  final String date;
  final String note;
  const CheckoutModel({
    this.id,
    this.isProcessing = false,
    this.isDelivered = false,
    this.note = '',
    required this.displayName,
    required this.cart,
    required this.total,
    required this.date,
  });

  CheckoutModel copyWith({
    String? id,
    String? note,
    bool? isProcessing,
    bool? isDelivered,
    String? displayName,
    List<CartModel>? cart,
    int? total,
    String? date,
  }) {
    return CheckoutModel(
      id: id ?? this.id,
      note: note ?? this.note,
      isProcessing: isProcessing ?? this.isProcessing,
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
      'note': note,
      'displayName': displayName,
      'isProcessing': isProcessing,
      'isDelivered': isDelivered,
      'cart': cart.map((x) => x.toMap()).toList(),
      'total': total,
      'date': date,
    };
  }

  factory CheckoutModel.fromSnapshot(DocumentSnapshot map) {
    return CheckoutModel(
      id: map['id'],
      note: map['note'] ?? '',
      displayName: map['displayName'] ?? '',
      isProcessing: map['isProcessing'] ?? false,
      isDelivered: map['isDelivered'] ?? false,
      cart: List<CartModel>.from(map['cart']?.map((x) => CartModel.fromMap(x))),
      total: map['total']?.toInt() ?? 0,
      date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    );
  }

  @override
  List<Object> get props {
    return [
      displayName,
      isProcessing,
      note,
      isDelivered,
      cart,
      total,
      date,
    ];
  }
}
