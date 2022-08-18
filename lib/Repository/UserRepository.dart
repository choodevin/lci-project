import '../DAO/FirebaseService.dart';
import '../Model/UserModel.dart';

class UserRepository extends FirebaseService<UserModel> {
  UserRepository() {
    super.model = UserModel();
  }
}
