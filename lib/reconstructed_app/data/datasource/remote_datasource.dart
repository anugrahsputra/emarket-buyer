import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_buyer/app/models/buyer_model.dart';
import 'package:emarket_buyer/app/models/location_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/domain.dart';

abstract class RemoteDatasource {
  Future<void> signUp(BuyerEntity buyer);
  Future<void> signIn(BuyerEntity buyer);
  Future<Position> getLocation();
  Future<String> getAddressFromLatLang(double lat, double lang);
  Future<void> saveUserToDatabase(BuyerEntity buyer);
  Future<bool> isSignedIn();
  Future<void> signOUt();
  Future<String> getCurrentUid();
}

class RemoteDatasourceImpl extends RemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  RemoteDatasourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<String> getCurrentUid() async => auth.currentUser!.uid;

  @override
  Future<Position> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      log('Error get position: $e');
      throw Exception();
    }
  }

  @override
  Future<String> getAddressFromLatLang(double lat, double lang) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lang, localeIdentifier: 'id');
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address =
            "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}";
        return address;
      } else {
        return 'Address is not found';
      }
    } catch (e) {
      return 'Error getting address: $e';
    }
  }

  @override
  Future<bool> isSignedIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> saveUserToDatabase(BuyerEntity buyer) async {
    try {
      final buyerCollection = firestore.collection('buyer');
      final id = await getCurrentUid();
      final location = await getLocation();
      final address =
          await getAddressFromLatLang(location.latitude, location.longitude);

      buyerCollection.doc(id).get().then((doc) {
        if (!doc.exists) {
          final newBuyer = BuyerModel(
            id: id,
            email: buyer.email,
            phoneNumber: buyer.phoneNumber,
            location: LocationModel(
              latitude: location.latitude,
              longitude: location.longitude,
            ),
            address: address,
            photoUrl:
                'https://ui-avatars.com/api/?background=random&name=${buyer.name}',
          ).toDocument();

          buyerCollection.doc(id).set(newBuyer);
        } else {
          log('this user already exist');
          return;
        }
      });
    } catch (e) {
      log('error saving user to database: $e');
      throw Exception();
    }
  }

  @override
  Future<void> signIn(BuyerEntity buyer) async {
    await auth.signInWithEmailAndPassword(
      email: buyer.email,
      password: buyer.password,
    );
  }

  @override
  Future<void> signOUt() async => auth.signOut();

  @override
  Future<void> signUp(BuyerEntity buyer) async {
    await auth
        .createUserWithEmailAndPassword(
            email: buyer.email, password: buyer.password)
        .then((value) => saveUserToDatabase(buyer));
  }
}
