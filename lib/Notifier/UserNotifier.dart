import 'package:flutter/cupertino.dart';

import '../Model/UserModel.dart';

class UserNotifier with ChangeNotifier {
  UserModel? user;

  void updateEmail(String email) {
    if (user == null) user = new UserModel.emptyConstructor();
    user?.email = email;
    notifyListeners();
  }
}
