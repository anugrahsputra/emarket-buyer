import 'package:emarket_buyer/models/seller_model.dart';
import 'package:emarket_buyer/services/database.dart';
import 'package:get/get.dart';

class SellerController extends GetxController {
  final Database database = Database();

  var seller = <SellerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSellers();
  }

  void fetchSellers() async {
    seller.bindStream(database.fetchAllSellers());
    update();
  }
}
