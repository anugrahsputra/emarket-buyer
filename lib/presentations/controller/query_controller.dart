import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:get/get.dart';

class QueryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Product> searchResult = RxList([]);

  void searchProduct(String query) async {
    QuerySnapshot snapshot = await _firestore
        .collectionGroup('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    searchResult.value =
        snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
  }
}
