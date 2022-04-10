import 'package:firebase_auth/firebase_auth.dart';

import '../Notifier/StateNotifier.dart';
import '../Service/UserService.dart';

class RegisterViewModel {
  User? _user;

  setUser(User user) {
    this._user = user;
  }

  Future<bool> checkRegisteredEmail(StateNotifier stateNotifier, String email) async {
    UserService userService = UserService();
    return await userService.checkRegisteredEmail(stateNotifier, email);
  }

  dynamic variableCallBack(dynamic notifier, dynamic variable) {
    return variable;
  }

  get user => _user;
}
