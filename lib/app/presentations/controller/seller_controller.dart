import 'package:emarket_buyer/app/models/seller_model.dart';
import 'package:emarket_buyer/app/services/services.dart';
import 'package:get/get.dart';

class SellerController extends GetxController {
  final Database database = Database();
  final Rx<SellerModel> seller = const SellerModel().obs;

  SellerModel get sellerModel => seller.value;

  set sellerModel(SellerModel value) {
    seller.value = value;
  }

  var sellers = <SellerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSellers();
  }

  void fetchSellers() async {
    sellers.bindStream(database.fetchAllSellers());
    update();
  }
}
