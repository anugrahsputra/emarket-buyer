import '../../domain/domain.dart';
import '../data.dart';

class BuyerRepositoryImpl extends BuyerRepository {
  final RemoteDatasource datasource;
  BuyerRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<String> getCurrentUid() async {
    return datasource.getCurrentUid();
  }

  @override
  Future<bool> isSignedIn() async {
    return datasource.isSignedIn();
  }

  @override
  Future<void> saveUserToDatabase(BuyerEntity buyer) async {
    return datasource.saveUserToDatabase(buyer);
  }

  @override
  Future<void> signIn(BuyerEntity buyer) async {
    return datasource.signIn(buyer);
  }

  @override
  Future<void> signOUt() async {
    return datasource.signOUt();
  }

  @override
  Future<void> signUp(BuyerEntity buyer) async {
    return datasource.signUp(buyer);
  }
}
