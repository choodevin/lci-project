import 'package:LCI/Notifier/StateNotifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/UserModel.dart';

class LandingViewModel {
  UserModel? _user;

  setUser(UserModel user) {
    this._user = user;
  }

  Future<bool> login(StateNotifier stateNotifier, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (Exception) {
      return false;
    }
  }

  UserModel? get user => _user;
}
