import 'package:emarket_buyer/services/database.dart';
import 'package:get/get.dart';

import '../models/model.dart';

class ProductController extends GetxController {
  final Database database = Database();
  RxBool loading = false.obs;

  var product = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void setLoading(bool value) {
    loading.value = value;
    update();
  }

  void fetchProducts() async {
    product.bindStream(database.fetchAllProducts());
    update();
  }
}
