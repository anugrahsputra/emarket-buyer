import '../domain.dart';

class SaveToDatabase {
  final BuyerRepository buyerRepo;
  SaveToDatabase({
    required this.buyerRepo,
  });

  Future<void> call(BuyerEntity buyer) async {
    return buyerRepo.saveUserToDatabase(buyer);
  }
}
