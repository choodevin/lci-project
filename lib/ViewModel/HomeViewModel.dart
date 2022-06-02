import 'package:LCI/Service/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/UserModel.dart';
import 'BaseViewModel.dart';

class HomeViewModel extends BaseViewModel {
  UserModel user = new UserModel();

  void loadCurrentUser() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    this.user = await UserService.getUserById(userId);
    notifyListeners();
  }
}