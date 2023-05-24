import 'package:emarket_buyer/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FcmController extends GetxController {
  Database database = Database();

  @override
  void onInit() {
    super.onInit();
    setupToken();
  }

  Future<void> saveTokenToDatabase(String token) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    database.saveToken(userId, token);
  }

  Future<void> setupToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await saveTokenToDatabase(token!);
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }
}
