import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_buyer/app/models/model.dart';
import 'package:equatable/equatable.dart';

class CheckoutModel extends Equatable {
  final String? id;
  final String buyerId;
  final String sellerId;
  final String displayName;
  final bool isProcessing;
  final bool isDelivered;
  final bool isCancelled;
  final bool isShipping;
  final List<CartModel> cart;
  final String address;
  final LocationModel location;
  final String additionalAddress;
  final int total;
  final String date;
  final Timestamp timestamp;
  final String note;
  const CheckoutModel({
    this.id,
    required this.buyerId,
    required this.sellerId,
    required this.displayName,
    required this.isProcessing,
    required this.isDelivered,
    required this.isCancelled,
    required this.isShipping,
    required this.cart,
    required this.address,
    required this.location,
    required this.additionalAddress,
    required this.total,
    required this.date,
    required this.timestamp,
    required this.note,
  });

  CheckoutModel copyWith({
    String? id,
    String? buyerId,
    String? sellerId,
    String? note,
    bool? isProcessing,
    bool? isDelivered,
    bool? isCancelled,
    bool? isShipping,
    String? displayName,
    List<CartModel>? cart,
    LocationModel? location,
    String? address,
    String? additionalAddress,
    int? total,
    String? date,
    Timestamp? timestamp,
  }) {
    return CheckoutModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      note: note ?? this.note,
      isProcessing: isProcessing ?? this.isProcessing,
      isCancelled: isCancelled ?? this.isCancelled,
      isDelivered: isDelivered ?? this.isDelivered,
      isShipping: isShipping ?? this.isShipping,
      displayName: displayName ?? this.displayName,
      cart: cart ?? this.cart,
      location: location ?? this.location,
      address: address ?? this.address,
      additionalAddress: additionalAddress ?? this.additionalAddress,
      total: total ?? this.total,
      date: date ?? this.date,
      timestamp: timestamp ?? this.timestamp,
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
      'isShipping': isShipping,
      'cart': cart.map((x) => x.toMap()).toList(),
      'location': location.toMap(),
      'address': address,
      'additionalAddress': additionalAddress,
      'total': total,
      'date': date,
      'timestamp': timestamp,
    };
  }

  factory CheckoutModel.fromDocument(DocumentSnapshot map) {
    return CheckoutModel(
      id: map['id'],
      buyerId: map['buyerId'],
      sellerId: map['sellerId'],
      note: map['note'] ?? '',
      displayName: map['displayName'] ?? '',
      isProcessing: map['isProcessing'] ?? false,
      isDelivered: map['isDelivered'] ?? false,
      isCancelled: map['isCancelled'] ?? false,
      isShipping: map['isShipping'] ?? false,
      cart: List<CartModel>.from(map['cart']?.map((x) => CartModel.fromMap(x))),
      location: LocationModel.fromMap(map['location']),
      address: map['address'],
      additionalAddress: map['additionalAddress'] ?? '',
      total: map['total']?.toInt() ?? 0,
      date: map['date'],
      timestamp: Timestamp.now(),
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
      isShipping,
      note,
      cart,
      location,
      address,
      additionalAddress,
      total,
      date,
      timestamp,
    ];
  }
}
