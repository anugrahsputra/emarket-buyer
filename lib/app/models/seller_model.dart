import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_buyer/app/models/model.dart';
import 'package:equatable/equatable.dart';

class SellerModel extends Equatable {
  final String id;
  final String displayName;
  final String storeName;
  final String address;
  final LocationModel location;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  const SellerModel({
    this.id = '',
    this.displayName = '',
    this.storeName = '',
    this.address = '',
    this.location = const LocationModel(),
    this.email = '',
    this.phoneNumber = '',
    this.photoUrl = '',
  });

  factory SellerModel.fromDocument(DocumentSnapshot snap) {
    return SellerModel(
      id: snap.id,
      displayName: snap['displayName'],
      storeName: snap['storeName'],
      address: snap['address'],
      location: LocationModel.fromMap(snap['location']),
      email: snap['email'],
      phoneNumber: snap['phoneNumber'],
      photoUrl: snap['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'storeName': storeName,
      'address': address,
      'location': location.toMap(),
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
    };
  }

  SellerModel copyWith({
    String? id,
    String? displayName,
    String? storeName,
    String? address,
    LocationModel? location,
    String? email,
    String? phoneNumber,
    String? photoUrl,
  }) {
    return SellerModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      storeName: storeName ?? this.storeName,
      address: address ?? this.address,
      location: location ?? this.location,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        storeName,
        address,
        location,
        email,
        phoneNumber,
        photoUrl,
      ];
}
