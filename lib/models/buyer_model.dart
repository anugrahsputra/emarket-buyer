import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BuyerModel extends Equatable {
  final String? id;
  final String displayName;
  final String email;
  final String photoUrl;
  const BuyerModel({
    this.id,
    this.displayName = '',
    this.email = '',
    this.photoUrl = '',
  });

  factory BuyerModel.fromSnapshot(DocumentSnapshot snapshot) {
    return BuyerModel(
      id: snapshot.id,
      displayName: snapshot['displayName'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  BuyerModel copyWith({
    String? id,
    String? displayName,
    String? storeName,
    String? email,
    String? photoUrl,
  }) {
    return BuyerModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, displayName, email, photoUrl];
}
