import '../domain.dart';

abstract class BuyerRepository {
  Future<void> signUp(BuyerEntity buyer);
  Future<void> signIn(BuyerEntity buyer);
  Future<void> saveUserToDatabase(BuyerEntity buyer);
  Future<bool> isSignedIn();
  Future<void> signOUt();
  Future<String> getCurrentUid();
}
