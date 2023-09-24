import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/domain.dart';
import '../data.dart';

class BuyerModel extends BuyerEntity {
  const BuyerModel({
    String id = '',
    String name = '',
    String email = '',
    String phoneNumber = '',
    LocationModel location = const LocationModel(),
    String address = '',
    String photoUrl = '',
  }) : super(
          id: id,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          location: location,
          address: address,
          photoUrl: photoUrl,
        );

  factory BuyerModel.fromDocument(DocumentSnapshot snap) {
    return BuyerModel(
      id: snap['id'],
      name: snap['name'],
      email: snap['email'],
      phoneNumber: snap['phoneNumber'],
      location: LocationModel.fromJson(snap['location']),
      address: snap['address'],
      photoUrl: snap['photoUrl'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'photoUrl': photoUrl,
      'location': location,
    };
  }
}
