import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:get/get.dart';

class QueryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Product> searchResult = RxList([]);
  RxString queryString = ''.obs;
  RxBool loading = false.obs;
  RxBool noResult = false.obs;
  int pageSize = 10; // number of results per page
  int currentPage = 1; // current page number

  @override
  void onInit() {
    super.onInit();
    debounce(queryString, (value) => query(value),
        time: const Duration(milliseconds: 500));
  }

  void setLoading(bool value) {
    loading.value = value;
    update();
  }

  void updateQuery(String query) {
    queryString.value = query;
  }

  void query(String query, {int page = 1}) async {
    setLoading(true);
    int startIndex = (page - 1) * pageSize;
    int endIndex = startIndex + pageSize;

    QuerySnapshot snapshot = await _firestore
        .collectionGroup('products')
        .orderBy('query')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .limit(endIndex)
        .get();

    int totalResults = snapshot.docs.length;

    if (totalResults == 0) {
      searchResult.clear();
      setLoading(false);
      noResult.value = true;
      return;
    }

    List<DocumentSnapshot> pageResults = snapshot.docs
        .sublist(startIndex, endIndex < totalResults ? endIndex : totalResults);

    searchResult.value =
        pageResults.map((doc) => Product.fromSnapshot(doc)).toList();
    currentPage = page;
    setLoading(false);
    noResult.value = false;
  }

  void clear() {
    queryString.value = '';
    searchResult.value = [];
    currentPage = 1;
  }
}
