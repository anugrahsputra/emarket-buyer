import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/services/database.dart';
import 'package:emarket_buyer/services/local_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CheckoutController extends GetxController {
  final Database database = Database();
  final LocalDatabase localDatabase = LocalDatabase();
  final BuyerController buyerController = Get.find<BuyerController>();
  final BuyerModel buyer = const BuyerModel();
  final SellerModel seller = const SellerModel();
  RxBool isLoading = false.obs;
  var uuid = const Uuid();
  DateTime date = DateTime.now();
  RxString formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now()).obs;

  final checkout = RxList<CheckoutModel>([]);

  @override
  void onInit() {
    fetchCheckout();
    super.onInit();
  }

  void setLoading(bool value) {
    isLoading.value = value;
    update();
  }

  fetchCheckout() async {
    String id = Get.find<AuthController>().user!.uid;
    checkout.bindStream(database.fetchCheckout(id));
    update();
  }

  newCheckout(CheckoutModel checkoutModel) async {
    String id = Get.find<AuthController>().user!.uid;
    Map<String, List<CartModel>> cartToSeller = {};
    for (CartModel cart in checkoutModel.cart) {
      String sellerId = cart.sellerId;
      if (!cartToSeller.containsKey(sellerId)) {
        cartToSeller[sellerId] = [];
      }
      cartToSeller[sellerId]!.add(cart);
    }
    for (String sellerId in cartToSeller.keys) {
      List<CartModel> sellerCart = cartToSeller[sellerId]!;

      int total =
          sellerCart.fold(0, (sum, cart) => sum + cart.price * cart.quantity);
      final newCheckout = CheckoutModel(
        id: uuid.v1(),
        buyerId: id,
        sellerId: sellerId,
        note: checkoutModel.note,
        displayName: checkoutModel.displayName,
        isProcessing: false,
        isDelivered: false,
        date: checkoutModel.date,
        cart: cartToSeller[sellerId]!,
        total: total,
      );
      await database.newCheckout(newCheckout, id);
    }
    await localDatabase.deleteProduct();
    update();
  }
}
