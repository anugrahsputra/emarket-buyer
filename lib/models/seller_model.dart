import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SellerModel extends Equatable {
  final String? id;
  final String displayName;
  final String storeName;
  final String email;
  final String photoUrl;
  const SellerModel({
    this.id,
    this.displayName = '',
    this.storeName = '',
    this.email = '',
    this.photoUrl = '',
  });

  factory SellerModel.fromSnapshot(DocumentSnapshot snap) {
    return SellerModel(
      id: snap.id,
      displayName: snap['displayName'],
      storeName: snap['storeName'],
      email: snap['email'],
      photoUrl: snap['photoUrl'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'displayName': displayName,
      'storeName': storeName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  SellerModel copyWith({
    String? id,
    String? displayName,
    String? storeName,
    String? email,
    String? photoUrl,
  }) {
    return SellerModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      storeName: storeName ?? this.storeName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        storeName,
        email,
        photoUrl,
      ];
}
