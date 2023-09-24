import '../domain.dart';

class Authentication {
  final BuyerRepository repo;
  Authentication({
    required this.repo,
  });

  Future<void> executeSignIn(BuyerEntity buyer) async => repo.signIn(buyer);

  Future<void> executeSignUp(BuyerEntity buyer) async => repo.signUp(buyer);

  Future<void> executeSignOut() async => repo.signOUt();

  Future<void> executeIsSignedIn() async => repo.isSignedIn();

  Future<void> executeGetCurrentUid() async => repo.getCurrentUid();
}
