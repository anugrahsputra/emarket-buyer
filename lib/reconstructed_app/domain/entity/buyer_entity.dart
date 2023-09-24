import 'package:equatable/equatable.dart';

import '../domain.dart';

class BuyerEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final LocationEntity location;
  final String address;
  final String photoUrl;

  const BuyerEntity({
    this.id = '',
    this.name = '',
    this.email = '',
    this.phoneNumber = '',
    this.password = '',
    this.location = const LocationEntity(),
    this.address = '',
    this.photoUrl = '',
  });

  @override
  List<Object> get props {
    return [
      id,
      name,
      email,
      phoneNumber,
      password,
      location,
      address,
      photoUrl,
    ];
  }
}
